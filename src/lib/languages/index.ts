import { LanguageSimplifiedChinese } from '@lib/languages/zh'
import { LanguageEnglish } from '@lib/languages/en'
import type { Language } from '@lib/languages/type'

export type { Language }
export const DEFAULT_LANGUAGE: Language = LanguageSimplifiedChinese
export const LANGUAGES: Record<string, Language> = {
  zh: LanguageSimplifiedChinese,
  en: LanguageEnglish,
}