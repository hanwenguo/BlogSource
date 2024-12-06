import { DEFAULT_LANGUAGE_CODE } from '@lib/constants'

export abstract class Language {
  // e.g. zh, en
  public abstract getCode(): string

  // e.g. zh-CN, en-US
  public abstract getFullCode(): string

  public abstract getDisplayName(): string

  public abstract getTimeZone(): string

  public isDefault(): boolean {
    return this.getCode() == DEFAULT_LANGUAGE_CODE
  }

  public getSegment(): string {
    return `/${this.getCode()}`
  }

  public is(language: Language): boolean {
    return language.getCode() == this.getCode()
  }

  public toString(): string {
    return this.getCode()
  }

  public getCanonicalPath(path: string, language: Language): string {
    const languagePathPrefix = this.getSegment()
    const pathWithoutLanguage = path.startsWith(languagePathPrefix)
      ? path.slice(languagePathPrefix.length)
      : path
    return language.getSegment() + pathWithoutLanguage
  }

  public abstract getTranslation(translationKey: string, args?: any): string
}