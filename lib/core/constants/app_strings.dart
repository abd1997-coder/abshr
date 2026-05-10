import 'package:intl/intl.dart';

class AppStrings {
  static final AppStrings _instance = AppStrings._internal();

  factory AppStrings() {
    return _instance;
  }

  AppStrings._internal();

  static String get locale => Intl.getCurrentLocale();

  static bool get isArabic => Intl.getCurrentLocale().startsWith('ar');

  // App
  static String get appName => isArabic ? 'السوق' : 'Marketplace';

  // Auth
  static String get login => isArabic ? 'دخول' : 'Login';
  static String get signup => isArabic ? 'إنشاء حساب' : 'Sign Up';
  static String get email => isArabic ? 'البريد الإلكتروني' : 'Email';
  static String get password => isArabic ? 'كلمة المرور' : 'Password';
  static String get logout => isArabic ? 'تسجيل خروج' : 'Logout';
  static String get confirmLogoutTitle => isArabic ? 'تسجيل الخروج' : 'Log out';
  static String get confirmLogoutMessage =>
      isArabic
          ? 'هل أنت متأكد أنك تريد تسجيل الخروج؟'
          : 'Are you sure you want to log out?';

  // Home
  static String get home => isArabic ? 'الرئيسية' : 'Home';
  static String get categories => isArabic ? 'الفئات' : 'Categories';
  static String get restaurants => isArabic ? 'المطاعم' : 'Restaurants';
  static String get sellers => isArabic ? 'البائعون' : 'Sellers';
  static String get search => isArabic ? 'البحث' : 'Search';

  // Profile
  static String get profile => isArabic ? 'الملف الشخصي' : 'Profile';
  static String get editProfile =>
      isArabic ? 'تعديل الملف الشخصي' : 'Edit Profile';
  static String get settings => isArabic ? 'الإعدادات' : 'Settings';
  static String get guest => isArabic ? 'ضيف' : 'Guest';
  static String get guestModeTitle =>
      isArabic ? 'أنت في وضع الضيف' : 'You are in guest mode';
  static String get guestModeMessage =>
      isArabic
          ? 'يجب تسجيل الدخول للوصول إلى هذه الصفحة.'
          : 'You must sign in to access this page.';

  // Orders
  static String get orders => isArabic ? 'الطلبات' : 'Orders';
  static String get favorites => isArabic ? 'المفضلة' : 'Favorites';
  static String get myOrders => isArabic ? 'طلباتي' : 'My Orders';
  static String get ongoing => isArabic ? 'جاري' : 'Ongoing';
  static String get history => isArabic ? 'السجل' : 'History';
  static String get trackOrder => isArabic ? 'تتبع الطلب' : 'Track Order';
  static String get rate => isArabic ? 'تقييم' : 'Rate';
  static String get cancel => isArabic ? 'إلغاء' : 'Cancel';
  static String get reOrder => isArabic ? 'طلب مرة أخرى' : 'Re-Order';

  // Address
  static String get addresses => isArabic ? 'العناوين' : 'Addresses';
  static String get myAddress => isArabic ? 'عنواني' : 'My Address';
  static String get addNewAddress =>
      isArabic ? 'إضافة عنوان جديد' : 'Add New Address';
  static String get editAddress => isArabic ? 'تعديل العنوان' : 'Edit Address';
  static String get address => isArabic ? 'العنوان' : 'ADDRESS';
  static String get street => isArabic ? 'الشارع' : 'STREET';
  static String get postCode => isArabic ? 'الرمز البريدي' : 'POST CODE';
  static String get apartment => isArabic ? 'الشقة' : 'APARTMENT';
  static String get labelAs => isArabic ? 'تصنيف باسم' : 'LABEL AS';
  static String get home2 => isArabic ? 'المنزل' : 'HOME';
  static String get work => isArabic ? 'العمل' : 'WORK';
  static String get other => isArabic ? 'أخرى' : 'OTHER';
  static String get saveLocation => isArabic ? 'حفظ الموقع' : 'SAVE LOCATION';
  static String get deleteAddress =>
      isArabic ? 'حذف العنوان' : 'Delete Address';
  static String get areYouSure =>
      isArabic
          ? 'هل أنت متأكد من رغبتك في حذف هذا العنوان؟'
          : 'Are you sure you want to delete this address?';
  static String get delete => isArabic ? 'حذف' : 'Delete';
  static String get setAsDefault =>
      isArabic ? 'تعيين كافتراضي' : 'Set as Default';

  // Product Detail
  static String get productDetails =>
      isArabic ? 'تفاصيل المنتج' : 'Food Details';
  static String get edit => isArabic ? 'تعديل' : 'EDIT';
  static String get breakfast => isArabic ? 'إفطار' : 'Breakfast';
  static String get delivery => isArabic ? 'توصيل' : 'Delivery';
  static String get ingredients => isArabic ? 'المكونات' : 'INGREDIENTS';
  static String get description => isArabic ? 'الوصف' : 'Description';
  static String get addToCart => isArabic ? 'أضف إلى السلة' : 'ADD TO CART';
  static String get reviews => isArabic ? 'التقييمات' : 'Reviews';

  // Cart
  static String get cart => isArabic ? 'السلة' : 'Cart';
  static String get cartSignInTitle =>
      isArabic ? 'سجّل الدخول لعرض السلة' : 'Sign in to view your cart';
  static String get cartSignInSubtitle =>
      isArabic
          ? 'أنشئ حساباً أو سجّل الدخول لإدارة سلتك وإتمام الطلب.'
          : 'Log in or create an account to manage your cart and checkout.';
  static String get cartSignedInToast =>
      isArabic ? 'تم تسجيل الدخول' : 'You’re signed in';
  static String get removeFromCartTitle =>
      isArabic ? 'إزالة من السلة' : 'Remove from cart';
  static String get removeFromCartMessage =>
      isArabic
          ? 'هل تريد إزالة هذا المنتج من السلة؟'
          : 'Remove this item from your cart?';
  static String get checkout => isArabic ? 'الدفع' : 'Checkout';
  static String get total => isArabic ? 'الإجمالي' : 'Total';
  static String get quantity => isArabic ? 'الكمية' : 'Quantity';
  static String get price => isArabic ? 'السعر' : 'Price';

  // Payment
  static String get payment => isArabic ? 'الدفع' : 'Payment';
  static String get paymentMethod =>
      isArabic ? 'طريقة الدفع' : 'Payment Method';
  static String get cardNumber => isArabic ? 'رقم البطاقة' : 'Card Number';
  static String get expiryDate => isArabic ? 'تاريخ الانتهاء' : 'Expiry Date';
  static String get cvv => isArabic ? 'رمز الأمان' : 'CVV';

  // Common
  static String get save => isArabic ? 'حفظ' : 'Save';
  static String get done => isArabic ? 'تم' : 'Done';
  static String get next => isArabic ? 'التالي' : 'Next';
  static String get previous => isArabic ? 'السابق' : 'Previous';
  static String get skip => isArabic ? 'تخطي' : 'Skip';
  static String get selectLanguage => isArabic ? 'اللغة' : 'Language';
  static String get english => isArabic ? 'الإنجليزية' : 'English';
  static String get arabic => isArabic ? 'العربية' : 'Arabic';
  static String get back => isArabic ? 'رجوع' : 'Back';
  static String get ok => isArabic ? 'حسناً' : 'OK';
  static String get error => isArabic ? 'خطأ' : 'Error';
  static String get success => isArabic ? 'نجح' : 'Success';
  static String get loading => isArabic ? 'جاري التحميل...' : 'Loading...';
  static String get tryAgain => isArabic ? 'حاول مرة أخرى' : 'Try Again';
  static String get retry => isArabic ? 'إعادة المحاولة' : 'Retry';
  static String get pleaseFillAllFields =>
      isArabic ? 'الرجاء ملء جميع الحقول' : 'Please fill all fields';

  // Network & API (friendly SnackBars for Dio errors)
  static String get errorNoInternet =>
      isArabic
          ? 'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.'
          : 'No internet connection. Check your network and try again.';
  static String get errorNetworkTimeout =>
      isArabic
          ? 'انتهت مهلة الاتصال. تحقق من الإنترنت ثم أعد المحاولة.'
          : 'Connection timed out. Check your internet and try again.';
  static String get errorServerUnavailable =>
      isArabic
          ? 'الخادم مشغول مؤقتاً. حاول بعد قليل.'
          : 'Our servers are busy. Please try again in a moment.';
  static String get errorRequestFailed =>
      isArabic
          ? 'تعذّر إتمام الطلب. حاول مرة أخرى.'
          : 'We couldn’t complete that request. Please try again.';
  static String get errorNotFound =>
      isArabic ? 'المحتوى غير موجود.' : 'We couldn’t find that.';
  static String get errorUnauthorized =>
      isArabic
          ? 'انتهت الجلسة أو التحقق مطلوب. سجّل الدخول من جديد.'
          : 'Your session expired or sign-in is required. Please log in again.';
  static String get errorForbidden =>
      isArabic
          ? 'لا تملك صلاحية لهذا الإجراء.'
          : 'You don’t have access to do that.';
  static String get errorTooManyRequests =>
      isArabic
          ? 'طلبات كثيرة جداً. انتظر قليلاً ثم حاول.'
          : 'Too many requests. Wait a moment and try again.';
  static String get errorSecureConnection =>
      isArabic
          ? 'مشكلة في الاتصال الآمن. حاول لاحقاً.'
          : 'Secure connection issue. Please try again later.';
  static String get errorSomethingWrong =>
      isArabic
          ? 'حدث خطأ ما. حاول مرة أخرى.'
          : 'Something went wrong. Please try again.';

  // Drawer
  static String get drawer => isArabic ? 'القائمة' : 'Menu';

  // Login & auth (screens)
  static String get loginTitle => isArabic ? 'تسجيل الدخول' : 'Log In';
  static String get loginSubtitle =>
      isArabic
          ? 'أدخل بريدك وكلمة المرور للدخول'
          : 'Enter your email and password to sign in';
  static String get emailUpper => isArabic ? 'البريد الإلكتروني' : 'EMAIL';
  static String get passwordUpper => isArabic ? 'كلمة المرور' : 'PASSWORD';
  static String get logInButton => isArabic ? 'دخول' : 'LOG IN';
  static String get continueAsGuest =>
      isArabic ? 'المتابعة كضيف' : 'CONTINUE AS GUEST';
  static String get dontHaveAccount =>
      isArabic ? 'ليس لديك حساب؟ ' : "Don't have an account? ";
  static String get signUpUpper => isArabic ? 'إنشاء حساب' : 'SIGN UP';
  static String get loginSuccessful =>
      isArabic ? 'تم تسجيل الدخول بنجاح' : 'Login successful';

  static String get signUpTitle => isArabic ? 'إنشاء حساب' : 'Sign Up';
  static String get signUpSubtitle =>
      isArabic ? 'أنشئ حساباً للبدء' : 'Please sign up to get started';
  static String get firstNameUpper => isArabic ? 'الاسم الأول' : 'FIRST NAME';
  static String get lastNameUpper => isArabic ? 'اسم العائلة' : 'LAST NAME';
  static String get retypePasswordUpper =>
      isArabic ? 'أعد إدخال كلمة المرور' : 'RE-TYPE PASSWORD';
  static String get signUpButton => isArabic ? 'إنشاء حساب' : 'SIGN UP';
  static String get accountCreatedSuccess =>
      isArabic ? 'تم إنشاء الحساب بنجاح' : 'Account created successfully';

  static String get forgotPasswordTitle =>
      isArabic ? 'نسيت كلمة المرور' : 'Forgot Password';
  static String get forgotPasswordSubtitle =>
      isArabic
          ? 'أدخل بريدك لإعادة تعيين كلمة المرور'
          : 'Please enter your email to reset password';
  static String get sendCode => isArabic ? 'إرسال الرمز' : 'SEND CODE';

  static String get verificationTitle => isArabic ? 'التحقق' : 'Verification';
  static String get verificationSentSubtitle =>
      isArabic
          ? 'أرسلنا رمزاً مكوّناً من 6 أرقام إلى هاتفك'
          : 'We have sent a 6-digit code to your phone';
  static String get codeUpper => isArabic ? 'الرمز' : 'CODE';
  static String get resend => isArabic ? 'إعادة الإرسال' : 'Resend';
  static String resendInSeconds(int s) =>
      isArabic ? 'إعادة الإرسال خلال $sث' : 'Resend in $s sec';
  static String get verifyButton => isArabic ? 'تحقق' : 'VERIFY';

  // Validation (forms)
  static String get validationEmailRequired =>
      isArabic ? 'الرجاء إدخال البريد الإلكتروني' : 'Please enter your email';
  static String get validationEmailInvalid =>
      isArabic
          ? 'الرجاء إدخال بريد إلكتروني صالح'
          : 'Please enter a valid email';
  static String get validationPasswordRequired =>
      isArabic ? 'الرجاء إدخال كلمة المرور' : 'Please enter your password';
  static String get validationFirstNameRequired =>
      isArabic ? 'الرجاء إدخال الاسم الأول' : 'Please enter your first name';
  static String get validationLastNameRequired =>
      isArabic ? 'الرجاء إدخال اسم العائلة' : 'Please enter your last name';
  static String get validationPasswordMin6 =>
      isArabic
          ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
          : 'Password must be at least 6 characters';
  static String get validationConfirmPassword =>
      isArabic ? 'الرجاء تأكيد كلمة المرور' : 'Please confirm your password';
  static String get validationPasswordsMismatch =>
      isArabic ? 'كلمتا المرور غير متطابقتين' : 'Passwords do not match';

  static String get hintEmailExample =>
      isArabic ? 'example@gmail.com' : 'example@gmail.com';
  static String get hintPasswordEnter =>
      isArabic ? 'أدخل كلمة المرور' : 'Enter your password';
  static String get hintReenterPassword =>
      isArabic ? 'أعد إدخال كلمة المرور' : 'Re-enter your password';
  static String get hintNameExample => isArabic ? 'محمد' : 'Mohamed';

  // Snackbars / errors
  static String get couldNotOpenWhatsApp =>
      isArabic
          ? 'تعذّر فتح واتساب. حاول لاحقاً.'
          : 'Could not open WhatsApp. Please try again later.';
  static String get completeSixDigitCode =>
      isArabic
          ? 'الرجاء إدخال الرمز المكوّن من 6 أرقام'
          : 'Please enter the complete 6-digit code';
  static String get verificationCodeResent =>
      isArabic ? 'تم إعادة إرسال رمز التحقق' : 'Verification code resent';
  static String get cartNotFound =>
      isArabic
          ? 'لم يُعثر على السلة. حاول مرة أخرى.'
          : 'Cart not found. Please try again.';
  static String get addedToFavorites =>
      isArabic ? 'تمت الإضافة إلى المفضلة' : 'Added to favorites';
  static String get removedFromFavorites =>
      isArabic ? 'تمت الإزالة من المفضلة' : 'Removed from favorites';
  static String get removeFromFavorites =>
      isArabic ? 'إزالة من المفضلة' : 'Remove from favorites';
  static String get noFavoritesYet =>
      isArabic ? 'لا توجد منتجات مفضلة بعد' : 'No favorites yet';
  static String get tapHeartToSaveProducts =>
      isArabic
          ? 'اضغط على رمز القلب في أي منتج لحفظه هنا.'
          : 'Tap the heart on any product to save it here.';
  static String get pleaseSignInValidEmail =>
      isArabic
          ? 'الرجاء تسجيل الدخول ببريد إلكتروني صالح.'
          : 'Please sign in with a valid email.';

  // Settings
  static String get settingsPageBody =>
      isArabic ? 'صفحة الإعدادات' : 'Settings page';

  // Profile
  static String get profileUpdatedSuccessfully =>
      isArabic ? 'تم تحديث الملف الشخصي بنجاح' : 'Profile updated successfully';
  static String get fullNameUpper => isArabic ? 'الاسم الكامل' : 'FULL NAME';
  static String get phoneNumberUpper =>
      isArabic ? 'رقم الهاتف' : 'PHONE NUMBER';
  static String get saveUpper => isArabic ? 'حفظ' : 'SAVE';

  // Address form (add/edit)
  static String get pickLocationOnMap =>
      isArabic
          ? 'اختر موقعاً على الخريطة واملأ تفاصيل العنوان.'
          : 'Pick a location on the map and fill address details.';
  static String get streetBuildingLabel =>
      isArabic ? 'الشارع / المبنى' : 'STREET / BUILDING';
  static String get cityUpper => isArabic ? 'المدينة' : 'CITY';
  static String get phoneUpper => isArabic ? 'الهاتف' : 'PHONE';
  static String get postCodeOptionalUpper =>
      isArabic ? 'الرمز البريدي (اختياري)' : 'POST CODE (OPTIONAL)';
  static String get apartmentOptionalUpper =>
      isArabic ? 'الشقة (اختياري)' : 'APARTMENT (OPTIONAL)';
  static String get apartmentShortUpper => isArabic ? 'الشقة' : 'APARTMENT';
  static String get apartmentFloorHint =>
      isArabic ? 'شقة / طابق' : 'Apt / floor';
  static String get apartmentNumberExample => '345';
  static String get pleaseFillStreetCityPhone =>
      isArabic
          ? 'الرجاء تعبئة الشارع والمدينة والهاتف'
          : 'Please fill street, city, and phone';
  static String get hintStreetExample =>
      isArabic ? 'شارع المزة 10' : 'Mazzeh Street 10';
  static String get hintCityDamascus => isArabic ? 'دمشق' : 'Damascus';
  static String get hintPhoneSyria =>
      isArabic ? '+963950000001' : '+963950000001';
  static String get optionalHint => isArabic ? 'اختياري' : 'Optional';
  static String get selectedLocation =>
      isArabic ? 'الموقع المحدد' : 'Selected location';
  static String get fillFormBelow =>
      isArabic ? 'املأ النموذج أدناه' : 'Fill the form below';

  static String get noSavedAddressesYet =>
      isArabic
          ? 'لا توجد عناوين محفوظة.\nاضغط الزر أدناه لإضافة عنوان.'
          : 'No saved addresses yet.\nTap the button below to add one.';
  static String get addNewAddressUpper =>
      isArabic ? 'إضافة عنوان جديد' : 'ADD NEW ADDRESS';

  // Orders
  static String get orderDetailsTitle =>
      isArabic ? 'تفاصيل الطلب' : 'Order details';
  static String get placedOn => isArabic ? 'تاريخ الطلب' : 'Placed on';
  static String get orderItemsSection => isArabic ? 'العناصر' : 'Items';
  static String get lineItemsUnavailable =>
      isArabic
          ? 'تفاصيل البنود غير متاحة لهذا الطلب. الإجماليات أدناه لا تزال صالحة.'
          : 'Line items are not available for this order. Totals below still apply.';
  static String get orderSummary => isArabic ? 'الملخص' : 'Summary';
  static String get orderTotalLabel => isArabic ? 'الإجمالي' : 'Total';

  // Cart checkout strip
  static String get whereShouldWeDeliver =>
      isArabic ? 'إلى أين نوصل؟' : 'Where should we deliver?';
  static String get tapAddressToUse =>
      isArabic
          ? 'اضغط على عنوان لاستخدامه لهذا الطلب.'
          : 'Tap an address to use it for this order.';
  static String get editList => isArabic ? 'تعديل القائمة' : 'Edit list';
  static String get defaultBadge => isArabic ? 'افتراضي' : 'Default';
  static String get cartEmpty => isArabic ? 'سلتك فارغة' : 'Your cart is empty';
  static String qtyLabel(int q) => isArabic ? 'الكمية $q' : 'Qty $q';
  static String get deliverTo => isArabic ? 'التوصيل إلى' : 'Deliver to';
  static String get deliverSubtitle =>
      isArabic
          ? 'سنوصل طلبك إلى هذا العنوان.'
          : 'We’ll bring your order to this address.';
  static String get loadingAddresses =>
      isArabic ? 'جاري تحميل العناوين…' : 'Loading your addresses…';
  static String get couldNotLoadAddresses =>
      isArabic ? 'تعذّر تحميل العناوين' : 'Couldn’t load addresses';
  static String get addDeliveryAddress =>
      isArabic ? 'أضف عنوان توصيل' : 'Add a delivery address';
  static String get tellUsWhereDelivery =>
      isArabic
          ? 'أخبرنا أين نوصل لإكمال طلبك.'
          : 'Tell us where to deliver so you can finish your order.';
  static String get addAddress => isArabic ? 'إضافة عنوان' : 'Add address';
  static String get totalColon => isArabic ? 'الإجمالي:' : 'TOTAL:';
  static String get placeOrder => isArabic ? 'إتمام الطلب' : 'PLACE ORDER';
  static String get doneUpper => isArabic ? 'تم' : 'DONE';
  static String get savedAddressFallback =>
      isArabic ? 'عنوان محفوظ' : 'Saved address';

  // Payment
  static String get payAndConfirm => isArabic ? 'ادفع وأكد' : 'PAY & CONFIRM';
  static String get congratulations =>
      isArabic ? 'تهانينا!' : 'Congratulations!';
  static String get paymentSuccessMessage =>
      isArabic
          ? 'تم الدفع بنجاح، نتمنى لك تجربة ممتعة!'
          : 'You successfully made a payment, enjoy our service!';
  static String get thankYou => isArabic ? 'شكراً لك' : 'THANK YOU';

  // Home / search
  static String get searchDishesHint =>
      isArabic ? 'ابحث عن أطباق، متاجر…' : 'Search dishes, shops';
  static String get searchProductsHint =>
      isArabic ? 'ابحث عن المنتجات' : 'Search products';
  static String get allCategories =>
      isArabic ? 'جميع الفئات' : 'All Categories';
  static String get allFilter => isArabic ? 'الكل' : 'All';
  static String get noSellersAtMoment =>
      isArabic ? 'لا يوجد بائعون حالياً' : 'No sellers at the moment';

  // Restaurant / products
  static String get noProductsYet =>
      isArabic ? 'لا توجد منتجات بعد' : 'No products yet';
  static String get noProductsInCategory =>
      isArabic ? 'لا توجد منتجات في هذه الفئة' : 'No products in this category';
  static String get defaultRestaurantName =>
      isArabic ? 'مطعم' : 'Spicy Restaurant';

  // Product detail
  static String reviewsCount(int n) => isArabic ? '$n مراجعة' : '$n reviews';
  static String get noReviewsYet =>
      isArabic ? 'لا مراجعات بعد' : 'No reviews yet';
  static String get subtotal => isArabic ? 'المجموع الفرعي' : 'Subtotal';
  static String addedToCart(int qty) =>
      qty == 1
          ? (isArabic ? 'تمت الإضافة إلى السلة' : 'Added to cart')
          : (isArabic
              ? 'تمت إضافة $qty عناصر إلى السلة'
              : 'Added $qty items to cart');
  static String addNToCart(int n) =>
      isArabic ? 'أضف $n إلى السلة' : 'ADD $n TO CART';

  // Onboarding
  static String get welcomeHeader => isArabic ? 'مرحباً' : 'Welcome';
  static String get welcomeTagline =>
      isArabic ? 'سوقك، ببساطة' : 'Your marketplace, simplified';
  static String get onboarding1Title =>
      isArabic ? 'مرحباً بك في السوق' : 'Welcome to Marketplace';
  static String get onboarding1Body =>
      isArabic
          ? 'اكتشف منتجات رائعة من بائعين حول العالم'
          : 'Discover amazing products from sellers around the world';
  static String get onboarding2Title => isArabic ? 'تسوق سهل' : 'Easy Shopping';
  static String get onboarding2Body =>
      isArabic
          ? 'تصفح وابحث واعثر على ما تحتاجه'
          : 'Browse, search, and find exactly what you need';
  static String get onboarding3Title =>
      isArabic ? 'مدفوعات آمنة' : 'Secure Payments';
  static String get onboarding3Body =>
      isArabic
          ? 'طرق دفع آمنة لجميع مشترياتك'
          : 'Safe and secure payment methods for all your purchases';
  static String get getStarted => isArabic ? 'ابدأ' : 'Get Started';

  // Popular food filters
  static String get filterYourSearch =>
      isArabic ? 'صفِّ بحثك' : 'Filter your search';
  static String get offersUpper => isArabic ? 'العروض' : 'OFFERS';
  static String get offers => isArabic ? 'العروض' : 'Offers';
  static String get deliverTimeUpper =>
      isArabic ? 'وقت التوصيل' : 'DELIVER TIME';
  static String get pricingUpper => isArabic ? 'السعر' : 'PRICING';
  static String get ratingUpper => isArabic ? 'التقييم' : 'RATING';
  static String get filterButton => isArabic ? 'تصفية' : 'FILTER';
  static String get filterDelivery => isArabic ? 'توصيل' : 'Delivery';
  static String get filterPickUp => isArabic ? 'استلام' : 'Pick Up';
  static String get filterOffer => isArabic ? 'عرض' : 'Offer';
  static String get time10to15 => isArabic ? '10-15 د' : '10-15 min';
  static String get time20 => isArabic ? '20 د' : '20 min';
  static String get time30 => isArabic ? '30 د' : '30 min';

  static String get searchSellersHint =>
      isArabic ? 'ابحث عن البائعين' : 'Search sellers';

  static String get categoryBurger => isArabic ? 'برجر' : 'BURGER';
  static String get popularBurgers =>
      isArabic ? 'أشهر البرجر' : 'Popular Burgers';
  static String get noPopularItemsYet =>
      isArabic ? 'لا عناصر شائعة بعد.' : 'No popular items yet.';
  static String get openShops => isArabic ? 'المتاجر المفتوحة' : 'Open Shops';
  static String get tastyTreatGallery =>
      isArabic ? 'معرض لذّة' : 'Tasty Treat Gallery';
  static String get burgerHaven => isArabic ? 'ملاذ البرجر' : 'Burger Haven';

  // Customer fallback (checkout)
  static String get customerFallback => isArabic ? 'عميل' : 'Customer';

  // Search page
  static String get recentKeywords =>
      isArabic ? 'البحث الأخير' : 'Recent Keywords';
  static String get recentSearchesAppearHere =>
      isArabic
          ? 'سيظهر هنا بحثك الأخير.'
          : 'Your recent searches will appear here.';
  static String get noSellersFound =>
      isArabic ? 'لم يُعثر على بائعين.' : 'No sellers found';

  static String get noResultsFound =>
      isArabic ? 'لم يُعثر على نتائج.' : 'No results found.';

  static String get products =>
      isArabic ? 'المنتجات' : 'Products';

  static String get currency => isArabic ? 'ل.س' : 'SYP';

  static String get failedToLoadSearchResults =>
      isArabic ? 'فشل تحميل نتائج البحث' : 'Failed to load search results';

  // Home page
  static String get goodMorning => isArabic ? 'صباح الخير' : 'Good morning';
  static String get goodAfternoon => isArabic ? 'ظهر الخير' : 'Good afternoon';
  static String get goodEvening => isArabic ? 'مساء الخير' : 'Good evening';

  // Orders page
  static String get noPastOrdersYet =>
      isArabic ? 'لا توجد طلبات سابقة.' : 'No past orders yet.';
  static String get noActiveOrders =>
      isArabic ? 'لا توجد طلبات نشطة.' : 'No active orders.';
  static String get activeOrdersTab => isArabic ? 'النشطة' : 'Active';
  static String get pastOrdersTab => isArabic ? 'السابقة' : 'Past';

  // Common error messages that may appear in UI
  static String get failedToLoadCategories =>
      isArabic ? 'فشل تحميل الفئات' : 'Failed to load categories';
  static String get failedToLoadSellers =>
      isArabic ? 'فشل تحميل البائعين' : 'Failed to load sellers';
  static String get failedToLoadOffers =>
      isArabic ? 'فشل تحميل العروض' : 'Failed to load offers';
  static String get failedToLoadOrders =>
      isArabic ? 'فشل تحميل الطلبات' : 'Failed to load orders';
  static String get failedToLoadAddresses =>
      isArabic ? 'فشل تحميل العناوين' : 'Failed to load addresses';
  static String get failedToLoadProduct =>
      isArabic ? 'فشل تحميل المنتج' : 'Failed to load product';
  static String get failedToLoadRestaurant =>
      isArabic ? 'فشل تحميل المطعم' : 'Failed to load restaurant';

  // Home page greeting
  static String get heyGreeting => isArabic ? 'مرحباً' : 'Hey';

  // Home - sellers section
  static String get seeAll => isArabic ? 'عرض الكل' : 'See All';

  static String get shopByCategory =>
      isArabic ? 'تسوق حسب الفئة' : 'Shop by category';
  static String get tapCategoryToRefreshSellers =>
      isArabic
          ? 'اضغط على فئة لتحديث البائعين'
          : 'Tap a category to refresh sellers';
  static String get bestProducts =>
      isArabic ? 'أفضل المنتجات' : 'Best products';
  static String get latestProducts =>
      isArabic ? 'أحدث المنتجات' : 'Latest products';
  static String get popularPicksAndProductOffers =>
      isArabic
          ? 'اختيارات شائعة وعروض منتجات'
          : 'Popular picks and product offers';
  static String get topSellers => isArabic ? 'أفضل البائعين' : 'Top sellers';
  static String get highlyRatedShops =>
      isArabic
          ? 'متاجر ذات تقييم عالٍ في المقدمة'
          : 'Highly rated shops near the front';
  static String get mostDeals => isArabic ? 'أكثر العروض' : 'Most deals';
  static String get freshOffersWorthChecking =>
      isArabic
          ? 'عروض جديدة تستحق المشاهدة الآن'
          : 'Fresh offers worth checking now';
  static String get swipeThroughMoreShops =>
      isArabic ? 'اسحب لرؤية المزيد من المتاجر' : 'Swipe through more shops';
  static String get shopNow => isArabic ? 'تسوق الآن' : 'Shop now';

  // Order directly
  static String get orderDirectly =>
      isArabic ? 'اطلب مباشرة' : 'Order directly';
  static String get free => isArabic ? 'مجاني' : 'Free';

  // Pricing filter
  static String get pricingLow => isArabic ? 'رخيص' : '\$';
  static String get pricingMedium => isArabic ? 'متوسط' : '\$\$';
  static String get pricingHigh => isArabic ? 'غالي' : '\$\$\$';

  // Delivery time
  static String get deliveryTime30Min => isArabic ? '30 دقيقة' : '30 min';
  static String get deliveryTime25Min => isArabic ? '25 دقيقة' : '25 min';
  static String get deliveryTime20Min => isArabic ? '20 دقيقة' : '20 min';
  static String get deliveryTime15Min => isArabic ? '15 دقيقة' : '15 min';

  // Free delivery symbol
  static String get freeDeliverySymbol => isArabic ? '☆ مجاني' : '☆ Free';
}
