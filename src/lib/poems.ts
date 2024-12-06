import { getCollection, type CollectionEntry } from 'astro:content'
import { type Language, LANGUAGES  } from '@lib/languages'

export class PoemClass {
    public readonly title: string
    public readonly date: Date
    public readonly year: number
    public readonly language: Language
    public readonly languageCode: string
    public readonly slug: string
    public readonly path: string
    public readonly body: string
    public readonly collectionEntry: CollectionEntry<'poems'> 

    constructor(post: CollectionEntry<'poems'>) {
        const [language, postsDir, ...paths] = post.id.split('/')
        this.title = post.data.title
        this.date = post.data.date
        this.year = this.date.getFullYear()
        this.language = LANGUAGES.zh
        this.languageCode = "zh"
        this.slug = paths.join('/')
        this.path = `/${language}/${postsDir}/${this.slug}/`
        this.body = post.body!
        this.collectionEntry = post
    }

    public static fromCollectionEntry(post: CollectionEntry<'poems'>): PoemClass {
        return new PoemClass(post)
    }
}

export async function getPoems(): Promise<PoemClass[]> {
    return (await getCollection('poems'))
        .map(PoemClass.fromCollectionEntry)
        .sort((a, b) => b.date.valueOf() - a.date.valueOf())
}