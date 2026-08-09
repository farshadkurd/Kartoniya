# 🎬 کارتونیا — فضای امن و شاد کودکان

**کارتونیا** یک اپلیکیشن Flutter فارسی و RTL برای پیدا کردن و تماشای محتوای کودک است. تجربهٔ برنامه برای کودک ساده و رنگی طراحی شده و بخش تنظیمات والدین با یک مسئلهٔ ریاضی تصادفی محافظت می‌شود.

> وضعیت فعلی: نسخهٔ ۱.۱.۰ یک کاتالوگ محلی، پخش‌کنندهٔ واقعی ویدئو، تنظیمات پایدار روی دستگاه و مسیر آماده برای اتصال به API/CMS دارد. محتوای نمایشی باید پیش از انتشار با ویدئوهای دارای مجوز جایگزین شود.

## قابلیت‌ها

- رابط **Material 3**، فارسی و کاملاً RTL با حالت روشن/تاریک
- Splash سبک و Onboarding سه‌مرحله‌ای
- خانه، دسته‌بندی، جست‌وجوی فارسی، علاقه‌مندی‌ها و فضای والدین
- ذخیرهٔ محلی علاقه‌مندی‌ها، نام نمایشی، تم، پخش خودکار و موقعیت ادامهٔ تماشا
- پخش‌کنندهٔ واقعی با `video_player`، کنترل پخش/توقف، جابه‌جایی ۱۰ ثانیه‌ای و ادامهٔ تماشا
- قفل والدین با مسئلهٔ تصادفی؛ بدون PIN ثابت
- حالت‌های Loading، Empty و Error برای جریان‌های اصلی
- طراحی واکنش‌گرا با گرید تطبیقی برای موبایل و تبلت
- صفحهٔ «درباره ما» اختصاصی Parsa Apps با هالهٔ طلایی متحرک و لینک تلگرام

## معماری

```
lib/
├── core/
│   ├── services/          # SharedPreferences wrapper
│   ├── theme/             # Design tokens و تم روشن/تاریک
│   └── utils/             # RTL، متن فارسی و System UI
├── data/
│   ├── models/            # CartoonModel و EpisodeModel
│   ├── providers/         # Riverpod state و composition root
│   └── repositories/      # LocalCartoonRepository
├── domain/
│   └── repositories/      # قرارداد CartoonRepository
└── presentation/
    ├── global_widgets/    # Parental Gate
    ├── pages/             # صفحات و جریان‌های کاربر
    └── widgets/           # کارت، artwork برداری و skeleton
```

UI فقط providerها را می‌خواند؛ provider کاتالوگ را از قرارداد `CartoonRepository` می‌گیرد. برای اتصال backend، یک repository جدید پیاده‌سازی و در `cartoonRepositoryProvider` جایگزین کنید؛ صفحه‌ها تغییر نمی‌کنند.

## پیش‌نیازها

- Flutter **3.19 یا بالاتر**
- Dart **3.2 یا بالاتر**
- Android SDK با `compileSdk 34`
- دستگاه یا شبیه‌ساز Android با حداقل API 21

## اجرا

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## ساخت خروجی Android

```bash
flutter build apk --release
flutter build appbundle --release
```

شناسهٔ فعلی برنامه `ir.parsaapps.kartoniya` است.

### امضای انتشار

فایل `android/key.properties` عمداً داخل Git نگه‌داری نمی‌شود. برای امضای فروشگاهی، آن را فقط روی محیط امن خودتان بسازید:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=YOUR_KEY_ALIAS
storeFile=/absolute/path/to/release.keystore
```

در نبود این فایل، Gradle یک APK release **با امضای debug فقط برای smoke test CI** می‌سازد. چنین فایلـی برای کافه‌بازار یا گوگل‌پلی قابل انتشار نیست.

## محتوا و پخش ویدئو

`LocalCartoonRepository` نمونهٔ محلی کاتالوگ است و برای تست فنی player از یک URL عمومی Flutter استفاده می‌کند. این URL محتوای تجاری کارتونیا نیست. پیش از انتشار:

1. URLهای قسمت را با CDN HTTPS و محتوای دارای حق پخش جایگزین کنید.
2. در صورت نیاز، repository API را با احراز هویت کوتاه‌عمر و cache امن پیاده‌سازی کنید.
3. رده‌بندی سنی، اطلاعات صاحب اثر و سیاست گزارش محتوا را برای هر عنوان ثبت کنید.
4. روی شبکهٔ ضعیف، قطع اینترنت و دستگاه‌های پایین‌رده تست دستی انجام دهید.

## حریم خصوصی و امنیت

- برنامه در نسخهٔ فعلی حساب کاربری، تبلیغ‌کننده یا analytics ندارد.
- فقط نام نمایشی والد، انتخاب تم، علاقه‌مندی‌ها و درصد ادامهٔ تماشا در `SharedPreferences` همان دستگاه ذخیره می‌شوند.
- مجوز Storage درخواست نمی‌شود و `requestLegacyExternalStorage` حذف شده است.
- ارتباط ویدئویی باید صرفاً HTTPS باشد.
- کلید امضای Android از repository حذف و در `.gitignore` محافظت شده است.

## تست‌های موجود

```bash
flutter test
```

- یکسان‌سازی جست‌وجوی فارسی/عربی
- اعتبار پایهٔ کاتالوگ محلی و URLهای HTTPS قسمت‌ها

## انتشار در کافه‌بازار و گوگل‌پلی

1. `applicationId`، نام، آیکون، اسکرین‌شات‌ها و سیاست حریم خصوصی را نهایی کنید.
2. فقط محتوا و تصاویر دارای مجوز را در کاتالوگ قرار دهید.
3. keystore انتشار را در محیط امن CI یا local تنظیم کنید.
4. AAB امضاشده بسازید: `flutter build appbundle --release`.
5. روی چند نسخهٔ Android و دستگاه واقعی، onboarding، قفل والدین، بازگشت از player، حالت تاریک و قطع اینترنت را تست کنید.
6. فرم‌های رده‌بندی سنی، Data Safety و اطلاعات پشتیبانی فروشگاه را تکمیل کنید.

جزئیات معماری و نقشهٔ راه صدمرحله‌ای در [`docs/ARCHITECTURE_FA.md`](docs/ARCHITECTURE_FA.md) و [`docs/ROADMAP_FA.md`](docs/ROADMAP_FA.md) آمده است.
