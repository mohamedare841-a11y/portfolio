// ==================== بيانات التطبيق ====================
const archaeologicalSites = [
    {
        id: 1,
        name: "المتحف المصري الكبير (GEM)",
        location: "منطقة الأهرامات، الجيزة",
        era: "العصر الحديث (متحف)",
        description: "أحد أكبر وأهم المتاحف الأثرية في العالم. يقع على بعد أمتار من الأهرامات ويعرض أكثر من 50,000 قطعة أثرية، أهمها المجموعة الكاملة لمقبرة توت عنخ آمون.",
        foreignPrice: "500-1000 جنيه (يختلف حسب القاعات)",
        egyptianPrice: "100-300 جنيه (يختلف حسب القاعات)",
        visitingHours: "مفتوح الآن (يوصى بالحجز المسبق عبر موقعه الرسمي). مواعيد العمل: 9 ص - 5 م (قد تتغير).",
        image: "https://earthsguards.com/wp-content/uploads/2025/06/musume2.jpg",
        basePrice: 500,
        egyptianBasePrice: 100
    },
    {
        id: 2,
        name: "أهرامات الجيزة",
        location: "الجيزة",
        era: "الدولة القديمة (أسرة 4)",
        description: "أشهر معالم مصر، وتضم ثلاثة أهرامات: خوفو (الأكبر)، خفرع، ومنقرع. بُنيت كمقابر ملكية وتعتبر إحدى عجائب الدنيا السبع القديمة والوحيدة التي لا تزال قائمة.",
        foreignPrice: "440 جنيه (منطقة الأهرامات) + 600 جنيه (دخول الهرم الأكبر)",
        egyptianPrice: "40 جنيه (منطقة الأهرامات) + 400 جنيه (دخول الهرم الأكبر)",
        visitingHours: "يوميًا: 8 ص - 5 م (شتاءً)، 7 ص - 7 م (صيفاً)",
        image: "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/06/7e/7d/2c/pyramids-of-giza.jpg?w=1200&h=1200&s=1",
        basePrice: 440,
        egyptianBasePrice: 40
    },
    {
        id: 3,
        name: "أبو الهول",
        location: "الجيزة",
        era: "الدولة القديمة (أسرة 4)",
        description: "تمثال أسطوري بجسم أسد ورأس إنسان، يُعتقد أنه يمثل الملك خفرع. يحرس هضبة الجيزة وهو منحوت من كتلة صخرية واحدة.",
        foreignPrice: "السعر مدرج في تذكرة منطقة الأهرامات",
        egyptianPrice: "السعر مدرج في تذكرة منطقة الأهرامات",
        visitingHours: "نفس أوقات منطقة الأهرامات",
        image: "https://www.independentarabia.com/sites/default/files/styles/1368x911/public/article/mainimage/2022/05/27/549211-1616005704.jpg",
        basePrice: 0,
        egyptianBasePrice: 0
    },
    {
        id: 4,
        name: "معبد الكرنك",
        location: "الأقصر",
        era: "الدولة الحديثة",
        description: "أكبر مجمع ديني قديم في العالم. كان مخصصًا لعبادة الثالوث الثيبي (آمون، موت، خونسو). يشتهر بصروحه الضخمة وقاعة الأعمدة الكبرى التي تضم 134 عمودًا.",
        foreignPrice: "300 جنيه",
        egyptianPrice: "40 جنيه",
        visitingHours: "يوميًا: 6 ص - 5:30 م (شتاءً)، 6 ص - 6 م (صيفًا)",
        image: "https://explore.rehlat.ae/static/media/searchdestination/thingstodo/images/luxor/temple_of_karnak/large_Templo_de_Karnak,_Luxor,_Egipto,.webp",
        basePrice: 300,
        egyptianBasePrice: 40
    },
    {
        id: 5,
        name: "معبد الأقصر",
        location: "الأقصر",
        era: "الدولة الحديثة (الأسرة 18)",
        description: "بني principalmente الملكان أمنحتب الثالث ورمسيس الثاني لاحتفالات عيد الأوبت. يتصل بمعبد الكرنك عبر طريق الكباش.",
        foreignPrice: "260 جنيه",
        egyptianPrice: "30 جنيه",
        visitingHours: "يوميًا: 6 ص - 10 م",
        image: "https://hurghadalovers.com/wp-content/uploads/2023/02/Luxor-Temple-Egyptian-Temples-Statue-of-King-Ramesses-II-Avenue-of-Sphinxes_0076-1140x530.jpg",
        basePrice: 260,
        egyptianBasePrice: 30
    },
    {
        id: 6,
        name: "وادي الملوك",
        location: "الضفة الغربية, الأقصر",
        era: "الدولة الحديثة",
        description: "مقبرة ملوك الدولة الحديثة، حيث كان يتم دفن الفراعنة في مقابر منحوتة في الصخر بعيدًا عن اللصوص. أشهرها مقبرة توت عنخ آمون.",
        foreignPrice: "400 جنيه (تذكرة أساسية لـ 3 مقابر) + تذاكر منفصلة لمقابر خاصة",
        egyptianPrice: "40 جنيه (تذكرة أساسية) + تذاكر منفصلة لمقابر خاصة",
        visitingHours: "يوميًا: 6 ص - 5 م (شتاءً)، 6 ص - 6 م (صيفًا)",
        image: "https://tripawayjo.com/wp-content/uploads/2023/11/11-66.jpg.webp",
        basePrice: 400,
        egyptianBasePrice: 40
    },
    {
        id: 7,
        name: "معبد حتشبسوت",
        location: "الدير البحري, الأقصر",
        era: "الدولة الحديثة (الأسرة 18)",
        description: "معبد جنائزي للملكة حتشبسوت، أحد أروع المعابد في مصر. يتميز بتصميمه الفريد المكون من ثلاثة طوابق متدرجة.",
        foreignPrice: "240 جنيه",
        egyptianPrice: "30 جنيه",
        visitingHours: "يوميًا: 6 ص - 5 م",
        image: "https://www.abou-alhool.com/ima/43465_IMG-20200130-WA0224.jpg",
        basePrice: 240,
        egyptianBasePrice: 30
    },
    {
        id: 8,
        name: "معبد أبو سمبل",
        location: "أسوان",
        era: "الدولة الحديثة (رمسيس الثاني)",
        description: "معبدان منحوتان في الصخر، بناهما رمسيس الثاني. تم نقلهما في الستينيات لإنقاذهما من الغرق بسبب بناء السد العالي.",
        foreignPrice: "415 جنيه",
        egyptianPrice: "50 جنيه",
        visitingHours: "يوميًا: 6 ص - 5 م",
        image: "https://mota.gov.eg/media/14dgp2m4/ab-samble.jpg?width=1240&height=524&rnd=133038464288800000",
        basePrice: 415,
        egyptianBasePrice: 50
    },
    {
        id: 9,
        name: "معبد فيلة",
        location: "أسوان",
        era: "العصر البطلمي والروماني",
        description: "معبد مخصص للإلهة إيزيس، تم نقله من جزيرة فيلة إلى جزيرة أجيليكا لإنقاذه من الغرق. يعتبر من أجمل المعابد في مصر.",
        foreignPrice: "300 جنيه",
        egyptianPrice: "40 جنيه",
        visitingHours: "يوميًا: 7 ص - 4 م",
        image: "https://api.soundandlight.show/photos/philae-show/philae-2.webp",
        basePrice: 300,
        egyptianBasePrice: 40
    },
    {
        id: 10,
        name: "معبد إدفو",
        location: "إدفو",
        era: "العصر البطلمي",
        description: "معبد مخصص للإله حورس، وهو من أفضل المعابد المحفوظة في مصر. يعد ثاني أكبر معبد بعد معبد الكرنك.",
        foreignPrice: "300 جنيه",
        egyptianPrice: "40 جنيه",
        visitingHours: "يوميًا: 7 ص - 4 م",
        image: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/The_Temple_of_Edfu_%D9%85%D8%B9%D8%A8%D8%AF_%D8%A7%D8%AF%D9%81%D9%88.jpg/330px-The_Temple_of_Edfu_%D9%85%D8%B9%D8%A8%D8%AF_%D8%A7%D8%AF%D9%81%D9%88.jpg",
        basePrice: 300,
        egyptianBasePrice: 40
    },
    {
        id: 11,
        name: "معبد كوم أمبو",
        location: "كوم أمبو",
        era: "العصر البطلمي",
        description: "معبد مزدوج مخصص للإلهين حورس وسوبek. يتميز بتصميمه الفريد حيث ينقسم إلى قسمين متماثلين.",
        foreignPrice: "240 جنيه",
        egyptianPrice: "30 جنيه",
        visitingHours: "يوميًا: 7 ص - 5 م",
        image: "https://mota.gov.eg/media/skudako0/kom-ombo.jpg?width=1240&height=524&rnd=133037827956070000",
        basePrice: 240,
        egyptianBasePrice: 30
    },
    {
        id: 12,
        name: "هرم سقارة المدرج",
        location: "سقارة",
        era: "الدولة القديمة (الأسرة 3)",
        description: "أقدم هرم في مصر، بني للملك زوسر. صممه المهندس إمحوتب ويعتبر أول بناء حجري ضخم في التاريخ.",
        foreignPrice: "180 جنيه",
        egyptianPrice: "30 جنيه",
        visitingHours: "يوميًا: 8 ص - 5 م",
        image: "https://cdn1-m.alittihad.ae/store/archive/image/2024/10/12/a82af69a-2c31-411d-9e66-c5bfc981e9bf.png",
        basePrice: 180,
        egyptianBasePrice: 30
    },
    {
        id: 13,
        name: "هرم ميدوم",
        location: "ميدوم",
        era: "الدولة القديمة (الأسرة 4)",
        description: "أحد أقدم الأهرامات في مصر، بني للملك حوني وأكمله سنفرو. يتميز بشكله الغريب الذي يشبه البرج.",
        foreignPrice: "100 جنيه",
        egyptianPrice: "20 جنيه",
        visitingHours: "يوميًا: 8 ص - 5 م",
        image: "https://upload.wikimedia.org/wikipedia/commons/3/37/%D9%87%D8%B1%D9%85_%D9%85%D9%8A%D8%AF%D9%88%D9%85.jpg",
        basePrice: 100,
        egyptianBasePrice: 20
    },
    {
        id: 14,
        name: "دهشور",
        location: "دهشور",
        era: "الدولة القديمة (الأسرة 4)",
        description: "موقع يضم هرمين للملك سنفرو: الهرم المنحني والهرم الأحمر. يعتبر الهرم الأحمر أول هرم حقيقي في مصر.",
        foreignPrice: "120 جنيه",
        egyptianPrice: "20 جنيه",
        visitingHours: "يوميًا: 8 ص - 5 م",
        image: "https://mota.gov.eg/media/zqce1zj3/%D8%AF%D9%87%D8%B4%D9%88%D8%B1-2.jpg?width=1055&height=593&rnd=133019010084830000",
        basePrice: 120,
        egyptianBasePrice: 20
    },
    {
        id: 15,
        name: "أبيدوس",
        location: "أبيدوس",
        era: "الدولة القديمة والحديثة",
        description: "من أهم المواقع الدينية في مصر القديمة، حيث كان مركز عبادة الإله أوزيريس. يضم معابد لستي الأول ورمسيس الثاني.",
        foreignPrice: "200 جنيه",
        egyptianPrice: "30 جنيه",
        visitingHours: "يوميًا: 7 ص - 5 م",
        image: "https://upload.wikimedia.org/wikipedia/commons/3/33/AbydosFacade.jpg",
        basePrice: 200,
        egyptianBasePrice: 30
    },
    {
        id: 16,
        name: "دندرة",
        location: "دندرة",
        era: "العصر البطلمي والروماني",
        description: "مجمع معابد مخصص للإلهة حتحور. يشتهر بمنظره الفلكي المحفوظ جيداً على سقف المعبد.",
        foreignPrice: "180 جنيه",
        egyptianPrice: "30 جنيه",
        visitingHours: "يوميًا: 7 ص - 5 م",
        image: "https://egymonuments.gov.eg//media/3108/Untitled1.jpg?center=0.50810810810810814,0.5&mode=crop&width=1200&height=630&rnd=133764904560000000",
        basePrice: 180,
        egyptianBasePrice: 30
    },
    {
        id: 17,
        name: "معبد الرامسيوم",
        location: "الأقصر",
        era: "الدولة الحديثة (رمسيس الثاني)",
        description: "معبد جنائزي لرمسيس الثاني، يضم تماثيل ضخمة للملك وآثاراً من معاركه الشهيرة.",
        foreignPrice: "120 جنيه",
        egyptianPrice: "20 جنيه",
        visitingHours: "يوميًا: 6 ص - 5 م",
        image: "https://egymonuments.gov.eg/media/8507/whatsapp-image-2024-11-19-at-114258-am.jpeg",
        basePrice: 120,
        egyptianBasePrice: 20
    },
    {
        id: 18,
        name: "معبد سيتي الأول",
        location: "أبيدوس",
        era: "الدولة الحديثة (الأسرة 19)",
        description: "معبد مخصص للإله أوزيريس، يشتهر بقائمة الملوك التي تسجل أسماء الفراعنة من مينا إلى سيتي الأول.",
        foreignPrice: "150 جنيه",
        egyptianPrice: "25 جنيه",
        visitingHours: "يوميًا: 7 ص - 5 م",
        image: "https://thebrainchamber.com/wp-content/uploads/2023/12/Temple-of-Seti-I-in-Abydos-3.jpg",
        basePrice: 150,
        egyptianBasePrice: 25
    },
    {
        id: 19,
        name: "معبد حورس",
        location: "إدفو",
        era: "العصر البطلمي",
        description: "أكبر معبد مخصص للإله حورس، وهو من أفضل المعابد المحفوظة في مصر. بني بين 237 و57 ق.م.",
        foreignPrice: "180 جنيه",
        egyptianPrice: "30 جنيه",
        visitingHours: "يوميًا: 7 ص - 4 م",
        image: "https://media.elwatannews.com/media/img/mediaarc/large/9979255141664096349.jpg",
        basePrice: 180,
        egyptianBasePrice: 30
    },
    {
        id: 20,
        name: "معابد الفنتين",
        location: "أسوان",
        era: "الدولة القديمة والحديثة",
        description: "مجموعة من المعابد على جزيرة الفنتين، تشمل معابد خنوم وساتت وآخرى. كانت مركزاً مهماً في العصور القديمة.",
        foreignPrice: "120 جنيه",
        egyptianPrice: "20 جنيه",
        visitingHours: "يوميًا: 7 ص - 4 م",
        image: "https://mota.gov.eg/media/y0cl1glw/%D8%A7%D9%84%D9%81%D9%86%D8%AA%D9%8A%D9%8A%D9%86-1.jpg?width=1240&height=524&rnd=133029140608270000",
        basePrice: 120,
        egyptianBasePrice: 20
    }
];

const egyptianKings = [
    {
        id: 1,
        name: "نارمر (مينا)",
        era: "العصر العتيق (الأسرة الأولى)",
        reign: "حوالي 3100 ق.م",
        description: "يعتبر أول ملك لمصر الموحدة ومؤسس الأسرة الأولى. قام بتوحيد مصر العليا والسفلى وأسس مدينة منف.",
        achievements: ["توحيد مصر العليا والسفلى", "تأسيس الأسرة الأولى", "تأسيس مدينة منف"],
        burial: "أبيدوس",
        image: "https://admin.almalnews.com/storage/uploads/2015/03/4af4354d-adb6-4ad2-bd4b-3776de74c3cc.jpg"
    },
    {
        id: 2,
        name: "خوفو",
        era: "الدولة القديمة (الأسرة الرابعة)",
        reign: "2589–2566 ق.م",
        description: "ثاني فراعنة الأسرة الرابعة، اشتهر ببناء الهرم الأكبر في الجيزة، أحد عجائب الدنيا السبع.",
        achievements: ["بناء الهرم الأكبر في الجيزة", "تطوير نظام إداري مركزي", "تعزيز التجارة الخارجية"],
        burial: "الهرم الأكبر بالجيزة",
        image: "https://upload.wikimedia.org/wikipedia/commons/5/59/Khufu.JPG"
    },
    {
        id: 3,
        name: "خفرع",
        era: "الدولة القديمة (الأسرة الرابعة)",
        reign: "2558–2532 ق.م",
        description: "رابع فراعنة الأسرة الرابعة، ابن خوفو. بنى الهرم الثاني في الجيزة وأبو الهول العظيم.",
        achievements: ["بناء الهرم الثاني بالجيزة", "تشييد تمثال أبو الهول", "تطوير الفن والعمارة المصرية"],
        burial: "الهرم الثاني بالجيزة",
        image: "https://egymonuments.gov.eg//media/3725/1.jpg?center=0.5,0.5036496350364964&mode=crop&width=1200&height=630&rnd=132581519640000000"
    },
    {
        id: 4,
        name: "منقرع",
        era: "الدولة القديمة (الأسرة الرابعة)",
        reign: "2532–2503 ق.م",
        description: "خامس فراعنة الأسرة الرابعة، ابن خفرع. بنى الهرم الثالث والأصغر في مجمع أهرامات الجيزة.",
        achievements: ["بناء الهرم الثالث بالجيزة", "تعزيز العلاقات التجارية", "تطوير النحت والفنون"],
        burial: "الهرم الثالث بالجيزة",
        image: "https://upload.wikimedia.org/wikipedia/commons/f/fb/Menkaura_Bust_Closeup.jpg"
    },
    {
        id: 5,
        name: "بيبي الثاني",
        era: "الدولة القديمة (الأسرة السادسة)",
        reign: "2278–2184 ق.م",
        description: "خامس فراعنة الأسرة السادسة، اعتلى العرش وعمره 6 سنوات وحكم لمدة 94 عاماً، وهو أطول فترة حكم في التاريخ.",
        achievements: ["أطول فترة حكم في التاريخ (94 عاماً)", "تنظيم بعثات تجارية", "بناء المعابد والمقابر"],
        burial: "هرم في سقارة",
        image: "https://www.annahar.com/Library/Images/Uploaded%20Images/2022/01/14/Mohamad/%D8%A7%D9%84%D9%85%D9%84%D9%83-%D8%A8%D9%8A%D8%A8%D9%8A-%D8%A7%D9%84%D8%AB%D8%A7%D9%86%D9%8A.jpg"
    },
    {
        id: 6,
        name: "منتوحتب الثاني",
        era: "الدولة الوسطى (الأسرة الحادية عشر)",
        reign: "2061–2010 ق.م",
        description: "مؤسس الدولة الوسطى، أعاد توحيد مصر بعد فترة الاضمحلال الأولى وانتقل العاصمة إلى طيبة.",
        achievements: ["إعادة توحيد مصر", "تأسيس الدولة الوسطى", "بناء المعابد في الدير البحري"],
        burial: "الدير البحري",
        image: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Mentuhotep_Seated.jpg/250px-Mentuhotep_Seated.jpg"
    },
    {
        id: 7,
        name: "أمنمحات الأول",
        era: "الدولة الوسطى (الأسرة الثانية عشر)",
        reign: "1991–1962 ق.م",
        description: "مؤسس الأسرة الثانية عشر، نقل العاصمة إلى إيثت تاوي وأعاد تنظيم الإدارة المركزية.",
        achievements: ["تأسيس الأسرة الثانية عشر", "نقل العاصمة إلى إيثت تاوي", "إصلاح النظام الإداري"],
        burial: "اللشت",
        image: "https://img.youm7.com/ArticleImgs/2020/5/7/10243-%D8%A3%D9%85%D9%86%D9%85%D8%AD%D8%A7%D8%AA-%D8%A7%D9%84%D8%A3%D9%88%D9%84-(1).jfif"
    },
    {
        id: 8,
        name: "سنوسرت الثالث",
        era: "الدولة الوسطى (الأسرة الثانية عشر)",
        reign: "1878–1839 ق.م",
        description: "أحد أعظم فراعنة الدولة الوسطى، وسع حدود مصر وقمع التمردات في النوبة وبنى القلاع العسكرية.",
        achievements: ["توسعة حدود مصر", "قمع التمردات في النوبة", "بناء القلاع العسكرية", "تطوير نظام الري"],
        burial: "دهشور",
        image: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Statue_of_Amenemhat_III_standing.jpg/960px-Statue_of_Amenemhat_III_standing.jpg"
    },
    {
        id: 9,
        name: "أحمس الأول",
        era: "الدولة الحديثة (الأسرة الثامنة عشر)",
        reign: "1550–1525 ق.م",
        description: "محرر مصر ومؤسس الدولة الحديثة، طرد الهكسوس من مصر ووحد البلاد من جديد.",
        achievements: ["طرد الهكسوس من مصر", "تأسيس الدولة الحديثة", "إعادة بناء المعابد"],
        burial: "دراع أبو النجا",
        image: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjrobPEuIFxiDf_yW3X4jgK1eNW4iu69J6nOxAkKXofNZjXG7nsZ9GlbG6PZQlemmE97wo_WD1cOI7MrZZVDtAgWmvPwI3BGWwatjemcz99mXxiGeAnp_Vwz9AUzwQUGZVw0RtRyaXPdPo/s1600/%25D9%2585%25D8%25A7+%25D9%2587%25D9%2589+%25D8%25A7%25D9%2587%25D9%2585+%25D8%25A7%25D8%25B9%25D9%2585%25D8%25A7%25D9%2584+%25D8%25A7%25D9%2584%25D9%2585%25D9%2584%25D9%2583+%25D8%25A7%25D8%25AD%25D9%2585%25D8%25B3+%25D8%25A7%D9%2584%25D8%25A7%D9%2588%D9%2584+%25D9%2582%25D8%25A7%25D9%2587%D8%25B1+%25D8%25A7%D9%2584%D9%2587%D9%2583%D8%25B3%D9%2588%D8%25B3+%25D9%2588%D9%2585%D9%2586+%25D9%2587%25D9%2585+%25D8%25A7%25D9%2588%25D9%2584%25D8%25A7%25D8%25AF%D9%2587+%25D8%25A7%D9%2584%D8%25B3%D8%25A8%25D8%25B9%25D8%25A9-5.jpg"
    },
    {
        id: 10,
        name: "حتشبسوت",
        era: "الدولة الحديثة (الأسرة الثامنة عشر)",
        reign: "1479–1458 ق.م",
        description: "أشهر ملكات مصر، حكمت كفرعون واشتهرت برحلاتها التجارية إلى بلاد بونت وبناء معبدها في الدير البحري.",
        achievements: ["تنظيم رحلات تجارية إلى بلاد بونت", "بناء معبد الدير البحري", "تطوير التجارة والاقتصاد"],
        burial: "وادي الملوك",
        image: "https://www.awanmasr.com/wp-content/uploads/2020/09/%D8%AD%D8%AA%D8%B4%D8%A8%D8%B3%D9%88%D8%AA.jpg"
    },
    {
        id: 11,
        name: "تحتمس الثالث",
        era: "الدولة الحديثة (الأسرة الثامنة عشر)",
        reign: "1479–1425 ق.م",
        description: "يُلقب بنابليون مصر، وسع الإمبراطورية المصرية إلى أقصى حدودها وقاد 17 حملة عسكرية ناجحة.",
        achievements: ["توسيع الإمبراطورية المصرية", "قيادة 17 حملة عسكرية", "بناء المسلات والمعابد"],
        burial: "وادي الملوك",
        image: "https://upload.wikimedia.org/wikipedia/commons/5/57/Thutmosis_III-2.jpg"
    },
    {
        id: 12,
        name: "أمنحتب الثالث",
        era: "الدولة الحديثة (الأسرة الثامنة عشر)",
        reign: "1388–1351 ق.م",
        description: "عرف بعصر الازدهار والسلام، بنى العديد من المعابد والتماثيل الضخمة بما فيها ممنون.",
        achievements: ["بناء معبد الأقصر", "تشييد تماثيل ممنون", "تطوير العلاقات الدبلوماسية"],
        burial: "وادي الملوك",
        image: "https://upload.wikimedia.org/wikipedia/commons/b/bb/Colossal_Amenhotep_III_British_Museum.jpg"
    },
    {
        id: 13,
        name: "أخناتون",
        era: "الدولة الحديثة (الأسرة الثامنة عشر)",
        reign: "1353–1336 ق.م",
        description: "الملك المصلح الذي حاول توحيد الآلهة في إله واحد هو آتون ونقل العاصمة إلى أخيتاتون.",
        achievements: ["الثورة الدينية (عبادة آتون)", "تأسيس العاصمة أخيتاتون", "تطوير الفن الواقعي"],
        burial: "وادي الملوك",
        image: "https://manshoor.com/uploads/2018/04/9a06e66509070cd057f3ec930819e434.jpg"
    },
    {
        id: 14,
        name: "توت عنخ آمون",
        era: "الدولة الحديثة (الأسرة الثامنة عشر)",
        reign: "1332–1323 ق.م",
        description: "أشهر فراعنة مصر بسبب اكتشاف مقبرته سليمة عام 1922. عاد للديانة التقليدية بعد فترة أخناتون.",
        achievements: ["العودة للديانة التقليدية", "إصلاح العلاقات مع الكهنة", "بناء المعابد"],
        burial: "وادي الملوك",
        image: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/CairoEgMuseumTaaMaskMostlyPhotographed.jpg/330px-CairoEgMuseumTaaMaskMostlyPhotographed.jpg"
    },
    {
        id: 15,
        name: "رمسيس الثاني",
        era: "الدولة الحديثة (الأسرة التاسعة عشر)",
        reign: "1279–1213 ق.م",
        description: "أعظم وأشهر فراعنة مصر، حكم لمدة 66 عاماً وبنى العديد من المعابد والتماثيل الضخمة.",
        achievements: ["معركة قادش", "بناء معبد أبو سمبل", "تشييد الرامسيوم", "توسيع الإمبراطورية"],
        burial: "وادي الملوك",
        image: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhHDffqGYostgOq_e-blVaQh6GVC3dePHDCHyT23UwFh-KDeypJ9adlArT8od8hTHfcjmzJLYpkD0iQxHvNSI2cz5xm-XXoIg2HBdtLOVBQeFOfwlbFZvhryUYXVeClQKIppv6VQ3tsL3k/s1600/10537448_1444175129202343_7652802320497538198_n.jpg"
    },
    {
        id: 16,
        name: "رمسيس الثالث",
        era: "الدولة الحديثة (الأسرة العشرون)",
        reign: "1186–1155 ق.م",
        description: "آخر الفراعنة العظام، دافع عن مصر ضد غزوات شعوب البحر وبنى معبد هابو في طيبة.",
        achievements: ["الدفاع عن مصر ضد شعوب البحر", "بناء معبد هابو", "تنظيم الاقتصاد والإدارة"],
        burial: "وادي الملوك",
        image: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhQQDo91_3Ag3eLHJHGQ7S0mQAst-tGU_8jmFiGQI1n7-4hlAveUTqCFG3DVlReRE02HYyaI38BNkVRnNx9JoTJoJyFhHNJeW-CeX1r1E8yrr03u_k7No3pp7ptPfYiozFELF_1avgSeF0/s1600/1610728593625512-1.png"
    },
    {
        id: 17,
        name: "بسماتيك الأول",
        era: "العصر المتأخر (الأسرة السادسة والعشرون)",
        reign: "664–610 ق.م",
        description: "مؤسس الأسرة السادسة والعشرون، حرر مصر من الاحتلال الآشوري وأعاد ازدهارها الثقافي والاقتصادي.",
        achievements: ["تحرير مصر من الآشوريين", "إحياء الفن والعمارة المصرية", "تنشيط التجارة"],
        burial: "سقارة",
        image: "https://gate.ahram.org.eg/Media/News/2021/7/25/19_2021-637628221971046423-104.jpg"
    },
    {
        id: 18,
        name: "نخت انبو الثاني",
        era: "العصر المتأخر (الأسرة الثلاثون)",
        reign: "360–342 ق.م",
        description: "آخر فرعون مصري أصلي حكم مصر، قاوم الغزو الفارسي وبنى العديد من المعابد والإصلاحات.",
        achievements: ["مقاومة الغزو الفارسي", "بناء وتجديد المعابد", "الإصلاحات الإدارية"],
        burial: "غير معروف",
        image: "https://upload.wikimedia.org/wikipedia/commons/c/c2/Head_of_Nectanebo_II-MBA_Lyon_H1701-IMG_0204.jpg"
    }
];

const timeZones = {
    'egypt': { name: 'مصر', offset: 2, summerOffset: 3, city: 'القاهرة' },
    'saudi': { name: 'السعودية', offset: 3, summerOffset: 3, city: 'الرياض' },
    'uae': { name: 'الإمارات', offset: 4, summerOffset: 4, city: 'أبوظبي' },
    'kuwait': { name: 'الكويت', offset: 3, summerOffset: 3, city: 'الكويت' },
    'qatar': { name: 'قطر', offset: 3, summerOffset: 3, city: 'الدوحة' },
    'oman': { name: 'عمان', offset: 4, summerOffset: 4, city: 'مسقط' },
    'gmt': { name: 'غرينتش', offset: 0, summerOffset: 1, city: 'لندن' },
    'est': { name: 'نيويورك', offset: -5, summerOffset: -4, city: 'نيويورك' }
};

const quizQuestions = [
    {
        id: 1,
        question: "ما هو أطول نهر في العالم؟",
        options: ["نهر النيل", "نهر الأمازون", "نهر المسيسيبي", "نهر اليانغتسي"],
        correct: 0,
        level: 1,
        points: 10,
        category: "جغرافيا",
        explanation: "نهر النيل هو أطول نهر في العالم بطول حوالي 6,650 كم."
    },
    {
        id: 2,
        question: "كم عدد الأهرامات الرئيسية في الجيزة؟",
        options: ["2", "3", "4", "5"],
        correct: 1,
        level: 1,
        points: 10,
        category: "آثار",
        explanation: "يوجد في الجيزة ثلاثة أهرامات رئيسية: خوفو، خفرع، ومنقرع."
    },
    {
        id: 3,
        question: "ما اسم الفرعون الذي بنى الهرم الأكبر؟",
        options: ["رمسيس الثاني", "خفرع", "خوفو", "توت عنخ آمون"],
        correct: 2,
        level: 1,
        points: 10,
        category: "ملوك",
        explanation: "الملك خوفو هو الذي بنى الهرم الأكبر في الجيزة."
    },
    {
        id: 4,
        question: "أين يقع تمثال أبو الهول؟",
        options: ["الأقصر", "الجيزة", "أسوان", "القاهرة"],
        correct: 1,
        level: 1,
        points: 10,
        category: "آثار",
        explanation: "يقع تمثال أبو الهول في هضبة الجيزة بالقرب من الأهرامات."
    },
    {
        id: 5,
        question: "ما هو اسم أول عاصمة لمصر الموحدة؟",
        options: ["طيبة", "الإسكندرية", "منف", "القاهرة"],
        correct: 2,
        level: 1,
        points: 10,
        category: "تاريخ",
        explanation: "منف كانت أول عاصمة لمصر الموحدة في العصر الفرعوني."
    },
    {
        id: 6,
        question: "كم عدد عجائب الدنيا السبع القديمة الموجودة في مصر؟",
        options: ["0", "1", "2", "3"],
        correct: 1,
        level: 1,
        points: 10,
        category: "آثار",
        explanation: "أهرامات الجيزة هي العجيبة الوحيدة الباقية من عجائب الدنيا السبع القديمة."
    },
    {
        id: 7,
        question: "ما هو اسم أهم إله في الديانة المصرية القديمة؟",
        options: ["أوزوريس", "رع", "حورس", "أنوبيس"],
        correct: 1,
        level: 1,
        points: 10,
        category: "ديانة",
        explanation: "رع كان إله الشمس وأهم إله في الديانة المصرية القديمة."
    },
    {
        id: 8,
        question: "ما هو نوع الكتابة التي استخدمها المصريون القدماء؟",
        options: ["الهيروغليفية", "الهيراطيقية", "الديموطيقية", "جميع ما سبق"],
        correct: 3,
        level: 1,
        points: 10,
        category: "لغة",
        explanation: "استخدم المصريون القدماء ثلاثة أنواع من الكتابة: الهيروغليفية، الهيراطيقية، والديموطيقية."
    },
    {
        id: 9,
        question: "من هو الفرعون الطفل؟",
        options: ["توت عنخ آمون", "رمسيس الثاني", "أخناتون", "أمنحتب الثالث"],
        correct: 0,
        level: 1,
        points: 10,
        category: "ملوك",
        explanation: "توت عنخ آمون اشتهر بأنه الفرعون الطفل حيث اعتلى العصر وعمره 9 سنوات."
    },
    {
        id: 10,
        question: "ما هو الغرض الرئيسي من بناء الأهرامات؟",
        options: ["سكن الملوك", "مقابر للملوك", "معابد للآلهة", "مستودعات للحبوب"],
        correct: 1,
        level: 1,
        points: 10,
        category: "آثار",
        explanation: "بُنيت الأهرامات كمقابر للملوك الفراعنة."
    },
    {
        id: 11,
        question: "كم استغرق بناء الهرم الأكبر؟",
        options: ["10 سنوات", "20 سنة", "30 سنة", "40 سنة"],
        correct: 1,
        level: 2,
        points: 20,
        category: "آثار",
        explanation: "استغرق بناء الهرم الأكبر حوالي 20 سنة."
    },
    {
        id: 12,
        question: "من هو الفرعون الذي بنى معبد أبو سمبل؟",
        options: ["رمسيس الثاني", "تحتمس الثالث", "أمنحتب الثالث", "حتشبسوت"],
        correct: 0,
        level: 2,
        points: 20,
        category: "ملوك",
        explanation: "الملك رمسيس الثاني هو من بنى معبد أبو سمبل."
    },
    {
        id: 13,
        question: "ما هو اسم الزوجة الرئيسية لرمسيس الثاني؟",
        options: ["نفرتيتي", "كليوباترا", "نفرتاري", "حتشبسوت"],
        correct: 2,
        level: 2,
        points: 20,
        category: "ملوك",
        explanation: "نفرتاري كانت الزوجة الرئيسية والمفضلة لرمسيس الثاني."
    },
    {
        id: 14,
        question: "في أي عصر عاشت الملكة حتشبسوت؟",
        options: ["الدولة القديمة", "الدولة الوسطى", "الدولة الحديثة", "العصر المتأخر"],
        correct: 2,
        level: 2,
        points: 20,
        category: "ملوك",
        explanation: "عاشت الملكة حتشبسوت في الدولة الحديثة (الأسرة الثامنة عشر)."
    },
    {
        id: 15,
        question: "ما هو اسم الإله الذي كان على شكل ابن آوى؟",
        options: ["حورس", "أنوبيس", "ست", "أوزوريس"],
        correct: 1,
        level: 2,
        points: 20,
        category: "ديانة",
        explanation: "أنوبيس، إله التحنيط والموتى، كان يصور على شكل ابن آوى."
    },
    {
        id: 16,
        question: "أين تم اكتشاف مقبرة توت عنخ آمون؟",
        options: ["وادي الملوك", "وادي الملكات", "سقارة", "دهشور"],
        correct: 0,
        level: 2,
        points: 20,
        category: "آثار",
        explanation: "تم اكتشاف مقبرة توت عنخ آمون في وادي الملوك بالأقصر."
    },
    {
        id: 17,
        question: "ما هو الاسم الحقيقي لتوت عنخ آمون؟",
        options: ["توت عنخ آتون", "نب خبيرو رع", "عنخ إسن آمون", "خبر كا رع"],
        correct: 0,
        level: 2,
        points: 20,
        category: "ملوك",
        explanation: "اسمه الأصلي كان توت عنخ آتون، ثم تغير إلى توت عنخ آمون."
    },
    {
        id: 18,
        question: "كم عدد غرف دفن في الهرم الأكبر؟",
        options: ["1", "2", "3", "4"],
        correct: 2,
        level: 2,
        points: 20,
        category: "آثار",
        explanation: "يحتوي الهرم الأكبر على ثلاث غرف دفن: غرفة الملك، غرفة الملكة، والغرفة الأرضية."
    },
    {
        id: 19,
        question: "من هو المهندس الذي صمم هرم سقارة المدرج؟",
        options: ["حسي رع", "إمحوتب", "سنفرو", "خوفو"],
        correct: 1,
        level: 2,
        points: 20,
        category: "شخصيات",
        explanation: "المهندس إمحوتب هو الذي صمم هرم سقارة المدرج للملك زوسر."
    },
    {
        id: 20,
        question: "ما هو اسم العاصمة التي أسسها أخناتون؟",
        options: ["أخيتاتون", "تل العمارنة", "كلا الإجابتين", "لا شيء مما سبق"],
        correct: 2,
        level: 2,
        points: 20,
        category: "تاريخ",
        explanation: "أخيتاتون هي العاصمة الجديدة التي أسسها أخناتون، وتعرف اليوم بتل العمارنة."
    },
    {
        id: 21,
        question: "كم بلغ عدد أبناء رمسيس الثاني؟",
        options: ["50", "100", "150", "200"],
        correct: 1,
        level: 3,
        points: 30,
        category: "ملوك",
        explanation: "بلغ عدد أبناء رمسيس الثاني حوالي 100 ابن وابنة."
    },
    {
        id: 22,
        question: "ما هو اسم المعركة الشهيرة التي خاضها رمسيس الثاني ضد الحيثيين؟",
        options: ["قادش", "مجدو", "كارنك", "أبو سمبل"],
        correct: 0,
        level: 3,
        points: 30,
        category: "تاريخ",
        explanation: "معركة قادش هي المعركة الشهيرة التي خاضها رمسيس الثاني ضد الحيثيين."
    },
    {
        id: 23,
        question: "من هو الفرعون الذي حكم مصر لمدة 94 عاماً؟",
        options: ["رمسيس الثاني", "بيبي الثاني", "أمنحتب الثالث", "سنوسرت الثالث"],
        correct: 1,
        level: 3,
        points: 30,
        category: "ملوك",
        explanation: "بيبي الثاني حكم مصر لمدة 94 عاماً، وهي أطول فترة حكم في التاريخ."
    },
    {
        id: 24,
        question: "ما هو اسم أول فرعون مصري؟",
        options: ["نارمر", "مينا", "كلا الإجابتين", "خوفو"],
        correct: 2,
        level: 3,
        points: 30,
        category: "ملوك",
        explanation: "نارمر (المعروف أيضًا باسم مينا) يعتبر أول فرعون لمصر الموحدة."
    },
    {
        id: 25,
        question: "كم بلغ وزن كتلة الحجر المستخدمة في بناء الهرم الأكبر؟",
        options: ["1-2 طن", "2-5 أطنان", "5-10 أطنان", "10-15 طناً"],
        correct: 1,
        level: 3,
        points: 30,
        category: "آثار",
        explanation: "بلغ وزن كتل الحجر المستخدمة في بناء الهرم الأكبر بين 2-5 أطنان."
    },
    {
        id: 26,
        question: "ما هو اسم الكتاب الذي كان يرشد المصريين القدماء إلى الحياة الآخرة؟",
        options: ["كتاب الموتى", "كتاب التحنيط", "كتاب الآخرة", "كتاب الأرواح"],
        correct: 0,
        level: 3,
        points: 30,
        category: "ديانة",
        explanation: "كتاب الموتى كان النص الجنائزي الذي يرشد المصريين القدماء إلى الحياة الآخرة."
    },
    {
        id: 27,
        question: "من هو الفرعون الذي حاول توحيد الآلهة في إله واحد؟",
        options: ["أخناتون", "توت عنخ آمون", "رمسيس الثاني", "حتشبسوت"],
        correct: 0,
        level: 3,
        points: 30,
        category: "ملوك",
        explanation: "أخناتون حاول توحيد الآلهة في إله واحد هو آتون (قرص الشمس)."
    },
    {
        id: 28,
        question: "ما هو اسم القارب الشمسي الموجود بجانب الهرم الأكبر؟",
        options: ["مركب خوفو", "مركب رع", "المركب الجنائزي", "مركب الشمس"],
        correct: 0,
        level: 3,
        points: 30,
        category: "آثار",
        explanation: "مركب خوفو هو القارب الشمسي الذي اكتشف بجانب الهرم الأكبر."
    },
    {
        id: 29,
        question: "كم عدد الأعمدة في قاعة الأعمدة الكبرى في معبد الكرنك؟",
        options: ["122", "134", "144", "154"],
        correct: 1,
        level: 3,
        points: 30,
        category: "آثار",
        explanation: "تحتوي قاعة الأعمدة الكبرى في معبد الكرنك على 134 عموداً."
    },
    {
        id: 30,
        question: "من هو الفرعون الذي بنى الهرم الأحمر؟",
        options: ["سنفرو", "خوفو", "خفرع", "منقرع"],
        correct: 0,
        level: 3,
        points: 30,
        category: "ملوك",
        explanation: "الملك سنفرو هو الذي بنى الهرم الأحمر في دهشور."
    }
];