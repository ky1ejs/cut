
# Challenge
A big part of Cut is rerieving content from your watchlist and content you've rated. We store IDs of movies you want to watch and movies you've rated in our DB. 

The problem is that TMDB has no multi-get API, so when we return the [watch/rate]list to the client, we have to make one call to TMDB for every row we find, which just isn't performant enough.

# Solutions

1. Store the content in our DB when we first come across them
2. 


## Fetching worker challenges
I have TypeScript worker files working in my-tfc-bb, but it seems that that was due to a spacifc tsconfig version and other deps being just right to allow it to work. I can't find a way to neatly get this project to work with TypeScript workers without wrestling with the deps and toolchain a lot. 

* https://wanago.io/2019/05/06/node-js-typescript-12-worker-threads/ - Section: "TypeScript support in Worker Threads"
* Nice little explanation of worker threads: https://stackoverflow.com/a/69818802/3053366


