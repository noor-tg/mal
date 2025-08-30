# مال
هو تطبيق للإدارة المالية الشخصية
## الخصائص
1. مدخلات (دخل ، منصرف)
2. تصنيفات (طعام ، مشروع ، خدمة ، إيجار) (إسم مع نوع وربما وصف)
3. تقارير (مجاميع ورسوم بيانية)
4. حساب مستخدم
5. سمات (نهاري \ ليلي)
6. إستخراج بيانات (CSV, PDF)
7. حساب الارباح والخسائر
8. الميزانية

## قرارات
- كل شي سيخزن محلياً بشكل أساسي
- يمكن المزامنة مع الخادم بعد تجهيز النسخة الاولية (مصدر صحة المعلومة هي المحلي)
	- الاضافة (ال uuid) غير الموجود يضاف
	- التعديل يؤخذ من المحلي ويعدل على الموجود في السحاب
	- الحذف (كيف) ؟
- السمة النهارية هي الاساس وسيتم إضافة السمة الليلية لاحقاً

## ما تم إنجازه (نسخة ١)
1. [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;مدخلات
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تسجيل
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تفاصيل مدخل
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تعديل مدخل
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;حذف مدخل
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;بحث بسيط و متقدم (ترتيب)
2. [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;واجهة التقويم (حسابات المدخلات باليوم)
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تفاصيل يوم في التقويم (تصفية مدخلات باليوم)
3. [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تصنيفات (إعادة بناء بال bloc لتأكيد إكتمال الخاصية)
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تسجيل
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;قائمة
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;حذف
4. [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تقارير
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;رصيد (دخل - منصرفات)
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;مجموع منصرفات
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;مجموع دخل
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;رسم بياني لمجاميع الشهر باليوم (دخل ، منصرف يومي)
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;رسم بياني لمدخلات الشهر بالتصنيف كفطيرة
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;رسم بياني لمنصرفات الشهر بالتصنيف كفطيرة
	- [x]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;قائمة مدخلات اليوم
5. [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;سمات 
      _أخر شي في النسخة الاولية_
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;نهاري
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ليلي
6. [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;إستخراج بيانات
7. [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;حساب مستخدم
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تعديل البيانات الاساسية
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تسجيل دخول
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تسجيل خروج
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تسجيل مستخدم جديد
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;نسيت كلمة المرور (بصمة أو رمز الهاتف لتسجيل الدخول للحساب وتغيير كلمة المرور)
8. [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;الميزانية
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;إضافة ميزانية
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;حذف ميزانية 
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تعديل ميزانية
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;قائمة الميزانيات
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تفاصيل ميزانية
9. [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;حساب الارباح و الخسائر
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;لكل شهر

## ما تم إنجازه (نسخة ٢)
1. [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;مزامنة المدخلات
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تسجيل
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تعديل
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;حذف
2. [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;مزامنة التصنيفات
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تسجيل
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;حذف
3. [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;مزامنة المستخدم
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تسجيل
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;حذف
4. [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;مزامنة الميزانية
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تسجيل
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تعديل
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;حذف
5. [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;الشركة
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;إضافة
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تعديل
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;حذف
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;قائمة
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تفاصيل
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;معلومات أساسية
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ربط مدخلات مع شركة (إختياري)
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ربط ميزانية مع شركة (إختياري)
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;إدارة أعضاء مع شركة
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تفاصيل
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;إضافة
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;حذف
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;قائمة
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;مدخلات (بحث أساسي و متقدم)
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ميزانيات
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;رصيد
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;مجموع دخل
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;مجموع منصرف
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;رسم بياني أعمدة عن الارباح والخسائر اليومية
	- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;مزامنة
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;إضافة
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;تعديل
		- [ ]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;حذف