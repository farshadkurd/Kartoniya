# 🎬 کارتونیا (Kartoniya)

اپلیکیشن تماشای انیمیشن و کارتون مخصوص کودکان، طراحی شده با ❤️ و فلاتر.

## ✨ ویژگی‌ها

- 🎨 **رابط کاربری مدرن و کودکانه** — Material 3، گرادیان‌های ظریف، سایه‌های نرم
- 🔒 **سیستم امنیت والدین** — Parental Gate با مسائل ریاضی تصادفی
- ⚡ **مدیریت State پیشرفته** — Riverpod
- 🌟 **انیمیشن‌های نرم** — ترنزیشن‌ها، micro-interactions، افکت طلایی
- 🔍 **جستجو و دسته‌بندی** — فیلتر بر اساس دسته‌بندی و جستجوی متنی
- ❤️ **علاقه‌مندی‌ها** — ذخیره کارتون‌های مورد علاقه
- 📺 **پخش‌کننده ویدیو** — کنترل‌های زیبا با انیمیشن
- 🏗️ **معماری تمیز** — Clean Architecture با Riverpod

## 📱 صفحات

| صفحه | توضیح |
|------|-------|
| 🌟 اسپلش | انیمیشن ورودی با ذرات شناور |
| 🏠 خانه | بنر خوش‌آمدگویی، ویژه‌ها، جدیدها، گرید کارتون‌ها |
| 🏷️ دسته‌بندی | فیلتر بر اساس دسته‌بندی |
| ❤️ علاقه‌مندی | لیست کارتون‌های ذخیره‌شده |
| 🔍 جستجو | جستجو با پیشنهادات |
| 📺 جزئیات | اطلاعات کامل کارتون و لیست قسمت‌ها |
| ▶️ پخش | پخش‌کننده ویدیو با کنترل‌ها |
| ℹ️ درباره ما | اطلاعات سازنده با افکت طلایی |

## 🛠️ تکنولوژی‌ها

- **Flutter** 3.x
- **Riverpod** — مدیریت حالت
- **GoRouter** — ناوبری
- **Google Fonts** — فونت وزیرمتن
- **CachedNetworkImage** — کشینگ تصاویر
- **Shimmer** — انیمیشن لودینگ
- **Lottie** — انیمیشن‌های وکتوری

## 🚀 اجرای پروژه

```bash
# نصب وابستگی‌ها
flutter pub get

# اجرا در حالت دیباگ
flutter run

# ساخت APK
flutter build apk --release
```

## 📂 ساختار پروژه

```
lib/
├── main.dart
├── core/
│   ├── theme/
│   │   ├── app_colors.dart      # سیستم رنگ‌بندی
│   │   └── app_theme.dart       # تم اصلی
│   └── utils/
│       └── full_screen_utils.dart
├── data/
│   ├── models/
│   │   └── cartoon_model.dart   # مدل داده
│   └── providers/
│       └── cartoons_provider.dart # Riverpod providers
└── presentation/
    ├── pages/
    │   ├── splash_page.dart
    │   ├── home_page.dart
    │   ├── categories_page.dart
    │   ├── favorites_page.dart
    │   ├── search_page.dart
    │   ├── cartoon_detail_page.dart
    │   ├── player_page.dart
    │   └── about_us_page.dart
    ├── widgets/
    │   ├── cartoon_card.dart
    │   └── shimmer_loader.dart
    └── global_widgets/
        └── parental_gate_widget.dart
```

## 🎨 طراحی

- **رنگ‌های اصلی:** نارنجی گرم (#FF8A50) + آبی آسمانی (#5AC8FA)
- **فونت:** وزیرمتن (Vazirmatn) — مناسب فارسی
- **سبک:** مدرن، نرم، کودکانه با گرادیان‌های ظریف
- **RTL:** پشتیبانی کامل از راست‌به‌چپ

## 👨‍💻 سازنده

**فرشاد پارسا** — Parsa Apps

- 📱 تلگرام: [@Parsaappsadmin](https://t.me/Parsaappsadmin)

## 📄 مجوز

این پروژه برای استفاده شخصی و آموزشی است.
