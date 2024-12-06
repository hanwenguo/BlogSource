import { Language } from '@lib/languages/type'

const translationDict: Record<string, string | ((key: string) => string) | ((key: number) => string)> = {
  page: '页面',
  nth_page: (n: number) => `第 ${n} 页`,

  table_of_contents: '目录',

  tags: '标签',
  view_all: `查看所有`,

  all_posts: '所有文章',
  latest_posts: '最近的文章',
  show_more: '以及更多',
  language: '语言',

  not_found: '您要查找的页面不存在。',
  not_found_reason: '可能是输入了错误的网址，或者页面已经被移动或删除了。',
  back_to_home: '回到首页',

  all_poems: '诗们',

  feed_rss: 'RSS 订阅',
  feed_atom: 'Atom',
  feed_json: 'JSON',
}

class LanguageSimplifiedChineseImpl extends Language {
  public override getCode(): string {
    return 'zh'
  }

  public override getFullCode(): string {
    return 'zh-Hans'
  }

  public override getDisplayName(): string {
    return '简体中文'
  }

  public override getTimeZone(): string {
    return 'Asia/Shanghai'
  }

  public override getTranslation(translationKey: string, args?: any): string {
    if (args !== undefined) {
      return (translationDict[translationKey]! as (key: any) => string)(args)
    }
    return translationDict[translationKey]! as string
  }
}

export const LanguageSimplifiedChinese = new LanguageSimplifiedChineseImpl()