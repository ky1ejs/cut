
import DataLoader from "dataloader";
import prisma from "../prisma";
import { ResolvedContent, contentInclude } from "../resolvers/mappers/contentDbToGqlMapper";

export default class ContentDataLoader {
  private batchContentFetch = new DataLoader<string, ResolvedContent | undefined>(async (ids) => {
    const content = await prisma.content.findMany({
      where: {
        OR: ids.map((id) => ({ id }))
      },
      include: contentInclude
    })
    const keyedContent = new Map(content.map(m => [m.id, m]))
    return ids.map(id => keyedContent.get(id))
  })

  async getContent(id: string) {
    return this.batchContentFetch.load(id)
  }
}
