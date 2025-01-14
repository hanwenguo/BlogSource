import { Language } from '@lib/languages/type'

const translationDict: Record<string, string | ((key: string) => string) | ((key: number) => string)> = {
  page: 'Page',
  nth_page: (n: number) => `Page ${n}`,

  table_of_contents: 'ToC',

  tags: 'Tags',
  view_all: `View all`,

  all_posts: 'All posts',
  latest_posts: 'Latest posts',
  show_more: 'and more',
  language: 'Language',
  links: 'Links',
  links_page_description: 'Here are some interesting links I found on the internet.',

  not_found: 'The page you are looking for does not exist.',
  not_found_reason: 'It might be a typo, or the page has been moved or deleted.',
  back_to_home: 'Back to homepage',

  feed_rss: 'RSS Feed',
  feed_atom: 'Atom',
  feed_json: 'JSON',
}

class LanguageEnglishImpl extends Language {
  public override getCode(): string {
    return 'en'
  }

  public override getFullCode(): string {
    return 'en-US'
  }

  public override getDisplayName(): string {
    return 'English'
  }

  public override getTimeZone(): string {
    return 'America/Denver'
  }

  public override getTranslation(translationKey: string, args?: any): string {
    if (args !== undefined) {
      return (translationDict[translationKey]! as (key: any) => string)(args)
    }
    return translationDict[translationKey]! as string
  }
}

export const LanguageEnglish = new LanguageEnglishImpl()