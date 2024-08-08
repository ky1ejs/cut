
import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { ApolloServerPluginDrainHttpServer } from '@apollo/server/plugin/drainHttpServer';
import express from 'express';
import http from 'http';
import cors from 'cors';
import { Resolvers } from './__generated__/graphql';
import { readFileSync } from 'fs';
import contentCollectionResolver from './resolvers/query/movies';
import searchResolver from './resolvers/query/searchResolver';
import prisma from './prisma';
import addToWatchList from './resolvers/mutation/addToWatchlist';
import isOnWatchlistResolver from './resolvers/query/isOnWatchListResolver';
import WatchListDataLoader from './dataloaders/watchlist/watchListDataLoader';
import { GraphQLError } from 'graphql';
import removeFromWatchList from './resolvers/mutation/removeFromWatchList';
import { completeAccountWatchList, incompleteAccountWatchList, unknownAccountWatchList } from './resolvers/query/watchList';
import { GraphQLContext } from './graphql/GraphQLContext';
import importGenres from './tmbd/import-genres';
import completeAccount from './resolvers/mutation/completeAccount';
import follow from './resolvers/mutation/follow';
import unfollow from './resolvers/mutation/unfollow';
import isUsernameAvailable from './resolvers/query/isUsernameAvailable';
import getAccount from './resolvers/query/getAccount';
import AnnonymousWatchListDataLoader from './dataloaders/watchlist/annonymousWatchListDataLoader';
import { OFFLINE } from './constants';
import updateAccount from './resolvers/mutation/updateAccount';
import { uploadContactEmails, uploadContactNumbers } from './resolvers/mutation/uploadContacts';
import contactMatches from './resolvers/query/contactMatches';
import IsFollowingDataLoader from './dataloaders/isFollowingDataLoader';
import isFollowing from './resolvers/query/isFollowing';
import { getProfileById, getProfileByUsername } from './resolvers/query/getProfile';
import setPushToken from './resolvers/mutation/setPushToken';
import sendTestPush from './resolvers/query/sendTestPush';
import ContentDataLoader from './dataloaders/MovieDataLoader';
import UserDataLoader from './dataloaders/UserDataLoader';
import favoriteContent from './resolvers/query/favoriteContent';
import contentResolver, { getContent } from './resolvers/query/content/content';
import TMDB from './datasources/TMDB';
import dateScalar from './graphql/scalars/DateScalar';
import urlScalar from './graphql/scalars/UrlScalar';
import personResolver from './resolvers/query/person';
import seasonResolver from './resolvers/query/season';
import episodeResolver from './resolvers/query/episode';
import imageUploadUrl from './resolvers/query/image-upload-url';
import profileImageUploadResponse from './resolvers/mutation/profileImageUploadResponse';
import searchUsers from './resolvers/query/searchUsers';
import { followersResolver, followingResolver, profileFollowResolver } from './resolvers/query/follow';
import logOut from './resolvers/mutation/logOut';
import initiateAuthentication from './resolvers/mutation/initiateAuthentication';
import validateAuthentication from './resolvers/mutation/validateAuthentication';
import annonymousSignUp from './resolvers/mutation/annonymousSignUp';
import { deleteAccount, generateDeleteAccountCode } from './resolvers/mutation/deleteAccount';
import RatingDataLoader from './dataloaders/rating/ratingDataLoader';
import AnnonymousRatingDataLoader from './dataloaders/rating/annonymousRatingDataLoader';
import ratingResolver from './resolvers/query/ratingResolver';
import rate from './resolvers/mutation/rate';

const boot = async () => {
  if (!OFFLINE) await importGenres();

  const typeDefs = readFileSync('graphql/schema.graphql', { encoding: 'utf-8' });

  const resolvers: Resolvers = {
    Date: dateScalar,
    URL: urlScalar,
    Query: {
      account: getAccount,
      contentCollection: contentCollectionResolver,
      search: searchResolver,
      watchList: unknownAccountWatchList,
      content: contentResolver,
      isUsernameAvailable,
      contactMatches,
      profileById: getProfileById,
      profileByUsername: getProfileByUsername,
      person: personResolver,
      sendTestPush,
      season: seasonResolver,
      episode: episodeResolver,
      imageUploadUrl: imageUploadUrl,
      searchUsers,
      profileFollow: profileFollowResolver,
    },
    Mutation: {
      initiateAuthentication,
      validateAuthentication,
      addToWatchList,
      removeFromWatchList,
      completeAccount,
      follow,
      unfollow,
      updateAccount,
      uploadContactEmails,
      uploadContactNumbers,
      setPushToken,
      profileImageUploadResponse,
      logOut,
      annonymousSignUp,
      deleteAccount,
      generateDeleteAccountCode,
      rate
    },
    ContentInterface: {
      __resolveType: (movie) => {
        if (movie.__typename === 'ExtendedMovie') {
          return 'ExtendedMovie';
        }
        return 'ExtendedTVShow';
      },
      isOnWatchList: isOnWatchlistResolver,
      rating: ratingResolver
    },
    ExtendedMovie: {
      isOnWatchList: isOnWatchlistResolver,
      rating: ratingResolver
    },
    ExtendedTVShow: {
      isOnWatchList: isOnWatchlistResolver,
      rating: ratingResolver
    },
    Content: {
      isOnWatchList: isOnWatchlistResolver,
      rating: ratingResolver
    },
    Work: {
      isOnWatchList: isOnWatchlistResolver,
      rating: ratingResolver
    },
    AccountUnion: {
      __resolveType: (parent) => parent.__typename!
    },
    IncompleteAccount: {
      watchList: incompleteAccountWatchList
    },
    RatingResponse: {
      extendedContent: async (parent) => {
        if (!parent.content?.id) {
          throw new GraphQLError('Content not found');
        }
        const response = await getContent(parent.content.id, TMDB.instance);
        if (!response.result) {
          throw new GraphQLError('Content not found');
        }
        return response.result
      }
    },
    Profile: {
      isFollowing,
      favoriteContent,
      watchList: (parent, args, context, info) => completeAccountWatchList(parent, context, info),
      followers: followersResolver,
      following: followingResolver
    },
    ProfileInterface: {
      __resolveType: (parent) => parent.__typename!,
    },
    CompleteAccount: {
      favoriteContent,
      watchList: (parent, args, context, info) => completeAccountWatchList(parent, context, info),
      followers: followersResolver,
      following: followingResolver
    },
    ProfileUnion: {
      __resolveType: (parent) => parent.__typename!
    }
  };

  const app = express();
  const httpServer = http.createServer(app);

  const server = new ApolloServer<GraphQLContext>({
    typeDefs,
    resolvers,
    plugins: [ApolloServerPluginDrainHttpServer({ httpServer })],
  });

  await server.start();

  app.use(
    '/graphql',
    cors<cors.CorsRequest>(),
    express.json(),
    expressMiddleware(server, {
      context: async ({ req }) => {
        let context: GraphQLContext = {
          dataSources: {
            watchList: new WatchListDataLoader(prisma),
            annonymousWatchList: new AnnonymousWatchListDataLoader(prisma),
            ratingDataLoader: new RatingDataLoader(prisma),
            annonymousRatingDataLoader: new AnnonymousRatingDataLoader(prisma),
            isFollowing: new IsFollowingDataLoader(),
            content: new ContentDataLoader(),
            users: new UserDataLoader(),
            tmdb: TMDB.instance,
          }
        }
        const sessionId = req.headers.authorization;
        if (sessionId) {
          const userDevicePromise = prisma.device.findUnique({ where: { sessionId }, include: { user: true } });
          const annonUserDevicePromise = prisma.annonymousDevice.findUnique({ where: { sessionId }, include: { user: true } })
          const [userDevice, annonUserDevice] = await Promise.all([userDevicePromise, annonUserDevicePromise])
          if (userDevice) {
            context.userDevice = userDevice;
          }
          if (annonUserDevice) {
            context.annonymousUserDevice = annonUserDevice;
          }
          if (context.userDevice === undefined && context.annonymousUserDevice === undefined) {
            throw new GraphQLError('Unauthorized', { extensions: { code: 'UNAUTHORIZED' } });
          }
        }
        return context
      }
    }),
  );

  app.get('/test', (_, res) => {
    res.send('Hello from Express!');
  })

  const port = process.env.PORT || 4000;

  await new Promise<void>((resolve) => httpServer.listen({ port }, resolve));
  console.log(`📡 listening on port ${port}`);
}

export default boot;
