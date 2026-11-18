# تقرير اختبار قاعدة البيانات - Risk Scanner

## اسم الطالب: Database Developer
## قاعدة البيانات: risk_scanner_db

### 1. انشاء الجداول
- تم انشاء 7 جداول بنجاح: Users, Scan_History, Scanned_Items, Risk_Indicators, Risk_Results, Reports, Feedback

### 2. اختبار العلاقات Foreign Key
- حذف المستخدم يمسح كل السكانات بتاعته تلقائي بسبب ON DELETE CASCADE - ناجح

### 3. اختبار Unique
- محاولة ادخال نفس الايميل مرتين اترفضت - ناجح

### 4. اختبار Check
- محاولة ادخال rating = 7 اترفضت لان المسموح من 1 الى 5 - ناجح

### 5. اختبار Queries
- INSERT و UPDATE و DELETE و SELECT شغالين
- استعلام JOIN للمخاطر العالية رجع النتائج صح

### النتيجة النهائية
قاعدة البيانات جاهزة للتسليم لفريق Backend
