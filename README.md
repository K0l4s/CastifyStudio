# castify_studio

## Project Structure

lib/
├── core/                   # Các giá trị chung toàn app
│   ├── constants/          # Color, spacing, strings
│   ├── themes/             # App theme
│   ├── error/              # AppException, error mapper
│   └── routes/             # GoRouter setup
├── features/               # Chia theo từng tính năng
│   ├── auth/               # Tính năng đăng nhập, đăng ký
│   │   ├── data/           # Repository, data source (Firebase)
│   │   ├── domain/         # UseCases, Entities
│   │   └── presentation/   # UI + state (Provider/BLoC)
│   ├── profile/
│   ├── podcast/            # Upload, play, like, comment
│   └── dashboard/          # Trang chủ, trending, following
├── common/                 # Reusable widgets
│   ├── widgets/            # Button, Card, Avatar...
│   ├── styles/             # Padding, text style, spacing
│   └── dialogs/            # AlertDialog, LoadingDialog...
├── services/               # Firebase, Notification, Audio
├── config/                 # firebase_options.dart, env, app config
├── utils/                  # Formatter, Validators, Extension
└── main.dart
