import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

// A `main` function so that we can use async/await
async function main() {
  /**
   * Query all quotes
   */
  const quotes = await prisma.quote.findMany()

  // console.dir(quotes, { depth: Infinity })

  /**
   * query for quotes and include their authors
  */
  // const quoteAndAuthors = await prisma.quote.findMany({
  //   include: {
  //     author: true
  //   }
  // })

  // console.dir(quoteAndAuthors, { depth: Infinity })

  /**
   * filter quotes
   */
  // const filteredQuotes = await prisma.quote.findMany({
  //   where: {
  //     content: {
  //       contains: 'freedom'
  //     }
  //   }
  // })

  // console.dir(filteredQuotes, { depth: Infinity })

  /**
   * create an author
   */
  // const newQuote = await prisma.quote.create({
  //   data: {
  //     content: '...',
  //     author: {
  //       create: {
  //         firstName: '..'
  //       }
  //     }
  //   }
  // })
  // console.dir(newQuote, { depth: Infinity })


}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
