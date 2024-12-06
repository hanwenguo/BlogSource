import { getCollection, type CollectionEntry } from 'astro:content'
import { type Language, LANGUAGES, DEFAULT_LANGUAGE } from '@lib/languages'

export type CollectivePostProperties = {
    tags: (tag: string, tags: string[]) => boolean,
}

export const collectivePostProperties: CollectivePostProperties = { 
    'tags': (tag: string, tags: string[]) => tags.includes(tag),
 } as const

export class PostClass {
    public readonly title: string
    public readonly tags: string[]
    public readonly date: Date
    public readonly year: number
    public readonly language: Language
    public readonly languageCode: string
    public readonly slug: string
    public readonly path: string
    public readonly body: string
    public readonly collectionEntry: CollectionEntry<'blog'> 

    constructor(post: CollectionEntry<'blog'>) {
        const [language, postsDir, ...paths] = post.id.split('/')
        this.title = post.data.title
        this.tags = post.data.tags
        this.date = post.data.date
        this.year = this.date.getFullYear()
        this.language = LANGUAGES[language]
        this.languageCode = language
        this.slug = paths.join('/')
        this.path = `/${language}/${postsDir}/${this.slug}/`
        this.body = post.body!
        this.collectionEntry = post
    }

    public static fromCollectionEntry(post: CollectionEntry<'blog'>): PostClass {
        return new PostClass(post)
    }
}

export async function getPosts(): Promise<PostClass[]> {
    return (await getCollection('blog'))
        .map(PostClass.fromCollectionEntry)
        .sort((a, b) => b.date.valueOf() - a.date.valueOf())
}

export async function getPostsInLanguage(language: Language): Promise<PostClass[]> {
    return (await getCollection('blog'))
        .filter(post => post.id.startsWith(`${language}/`))
        .map(PostClass.fromCollectionEntry)
        .sort((a, b) => b.date.valueOf() - a.date.valueOf())
}