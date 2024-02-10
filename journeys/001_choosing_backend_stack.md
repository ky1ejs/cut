# Choosing the stack

Choices to make (with answers as TL;DR;)
* Hosting platform - Railway
* Language - TypeScript
* Database Host - Neon
* ORM - Prisma
* Wire format - GraphQL

## Needs
* Fast devx – I'm only one person, I need all the help I can get to make this quick and easy
* Fast performance – lets make an impact on the UX by making this app as fast as possible
* Realtime support – following on from the previous point, realtime can make delightful moments (e.g. likes updating)

## Hosting platform

Options:
- Render
- Fly.io
- Railway
- ~~DigtalOcean~~ - too expensive
- ~~Supabase~~ - I want to handle my database and auth myself for learning and control
- ~~AWS, GCP etc.~~ (but no, pricy af)

### Compare
| Platform | Has free tier? | Cost | Resources | Support PR envs/previews? |
| --- | --- | ---- | --- | --- | 
| Render | Yes, but it shuts down upon innactivity and it takes 6 (!!!) mins to boot back up | $7 | 512mb RAM / 0.1 CPU  | Yes |
| Railway | No | $5 | 8 GB RAM / 8 vCPU per Service | Yes | 
| Fly.io | Yes | $5 free-credit, then depends on usage | Up to 3 shared-cpu-1x 256mb VMs  | Yes, via [GitHub Actions](https://github.com/superfly/fly-pr-review-apps) | 

Some comparison links:
https://www.reddit.com/r/webdev/comments/14pl5et/railway_free_developer_plan_will_be_gone_where_to/

### Railway
#### Pros
* slick interface and GitHub integration
* super generous resource allowance for 5$
* interested in the idea of running postgres in Railway for speed, but if it's totally self managed (e.g. memory usage etc. etc.) then I'm not sure it's for me
#### Cons
* don't love that secrets are availble to view in your dashboard... wish these were only writable not readble. Followed up with Railway about this but they [didn't think it was a problem](https://discord.com/channels/713503345364697088/1082212195775029310/1204201807505784924).

### Fly.io
#### Reviews 
https://www.reddit.com/r/devops/comments/10eg6a1/i_believe_i_can_fly_a_flyio_review/

## Language
Really I'm only going to go with TypeScript because the toolchain is excellent and I find it so fast to work with. 

Others I would have considered: 
* Ruby – everyone knows it's really fast for building new apps, but I'm already set with TS
* Elixir – everyone talks about this lately. I took a look at the getting started and seems like I'd spend too much time learning for now rather than getting this done
* Rust (!) – same as above
* Swift / Kotlin – I'm sure the toolchain will annoy me at some point


## Database
I love working with relational databases and they perform extremely well for quite some time (if this blows up the point where SQL is no longer working, I think that's a good problem to have).

The question is who hosts it? I want these features: 
* Easy access and set up
* Free tier
* Support for LISTEN and NOTIFY so we can support some realtime functionality

Options:
* [Neon](https://neon.tech/)
* [Crunchy](https://www.crunchydata.com/products/crunchy-high-availability-postgresql)
* [~~Fly.io Postres~~](https://fly.io/docs/postgres/) - [it's not managed](https://fly.io/docs/postgres/getting-started/what-you-should-know/)
* [~~Render~~](https://render.com/) – free tier db "expires" (shuts down until you pay) [after 90-days](https://docs.render.com/free#90-day-limit)
* [~~Digital Ocean~~](https://www.digitalocean.com/pricing) - no free tier
* [~~Cockroach DB~~](https://www.cockroachlabs.com/pricing/) sadly does not support LISTEN / NOTIFY, although has [it's own proprietary approach](https://www.cockroachlabs.com/docs/stable/changefeed-for)

I'm going to go with Neon because: 
- it's what Vercel use for their Postgres product (quote from [here](https://neon.tech/docs/guides/vercel-postgres): Vercel Storage is a collection of managed storage products that you can integrate with your frontend framework. Included in this suite of products is Vercel Postgres, which is serverless Postgres powered by Neon.)
- it's Postgres, where as CockroachDB is its own thing
- I love its branching support -- could be super helpful for experimenting

## ORM
Options: 
* https://orm.drizzle.team/
* https://www.prisma.io/client

I've been using Prisma on all my project so far, but the performance claims of Drizzle are very interesting (see their home page for a side by side live test of Prisma vs Drizzle).

Prisma offer there own comparison of the two [here](https://www.prisma.io/docs/orm/more/comparisons/prisma-and-drizzle), TL;DR; Prisma has more features while Drizzle is kept more raw and powerful for those more familiar with SQL.

Prisma does have two very cool add-on products that are of interest to me: 
- [Pulse](https://accelerate-speed-test.prisma.io/#testArea) - realtime updates from you DB
- [Accelerate](https://www.prisma.io/data-platform/accelerate) - edge caching for you database

These products are very, very tempting... not gonna lie.

Some other great comparisons of ORMs:
- https://www.reddit.com/r/node/comments/14lyyia/prisma_vs_drizzle_orm_for_production/
- https://www.reddit.com/r/node/comments/176zyyh/pick_an_orm_for_2024_and_explain_the_good_the_bad/

I was very tempted to go with Drizzle to try out the performance, but for the following reasons I'll go with Prisma:
- I already know it
- I prefer the api (e.g. I don't love that you have to refernce table objects when querying)
- It has tons of tooling (although Drizzle has a fair bit too)
- It has some perf features I could use anyway if the perf gets lower

## Wire format
Options:
* GraphQL
* Protobuf (and gRPC)

After reading [this post](https://stackoverflow.blog/2022/11/28/when-to-use-grpc-vs-graphql/) and having made a TS backend + iOS app before that uses gRPC, I have been convinced to go with GraphQL. 

It's better supported in mobile and web clients and I found I had to wrestly a bit to get the gRPC server connecting to my iOS app in the past (in that case it was down to some issues running over IPv6). 

## Realtime Updates
Saving these links I found for when I'm ready to come back to this:
- https://www.youtube.com/watch?v=Z_nOzHmpY8M 
- https://github.com/supabase/realtime
- https://www.crunchydata.com/blog/real-time-database-events-with-pg_eventserv
- https://neon.tech/blog/http-vs-websockets-for-postgres-queries-at-the-edge
- https://news.ycombinator.com/item?id=26968449
- https://www.apollographql.com/docs/react/data/subscriptions/

