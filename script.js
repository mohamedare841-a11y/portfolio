// script.js
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
    // ... باقي المعالم الأثرية (20 معلم)
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
    // ... باقي الملوك (18 ملك)
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

let currentTimezone = 'egypt';
let isSummerTime = false;

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
    // ... باقي الأسئلة (30 سؤال)
];

// ==================== الوظائف الأساسية ====================
function detectSystemLanguage() {
    const systemLang = navigator.language || navigator.userLanguage;
    return systemLang.startsWith('ar') ? 'ar' : 'en';
}

function checkSummerTime(date) {
    const month = date.getMonth();
    const day = date.getDate();
    
    if (month > 4 && month < 9) {
        return true;
    }
    
    if (month === 3 && day >= 25) return true;
    if (month === 9 && day <= 25) return true;
    
    return false;
}

function formatDateTime(date, language = 'ar') {
    if (language === 'ar') {
        const arabicDays = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
        const arabicMonths = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
        
        const dayName = arabicDays[date.getDay()];
        const day = date.getDate();
        const monthName = arabicMonths[date.getMonth()];
        const year = date.getFullYear();
        
        return `${dayName}، ${day} ${monthName} ${year}`;
    } else {
        return date.toLocaleDateString('en-US', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    }
}

function formatTime12Hour(date, timezone = 'egypt') {
    const timezoneInfo = timeZones[timezone];
    const isSummer = checkSummerTime(date);
    const offset = isSummer ? timezoneInfo.summerOffset : timezoneInfo.offset;
    
    const utcTime = date.getTime() + (date.getTimezoneOffset() * 60000);
    const localTime = new Date(utcTime + (3600000 * offset));
    
    let hours = localTime.getHours();
    const minutes = localTime.getMinutes().toString().padStart(2, '0');
    const seconds = localTime.getSeconds().toString().padStart(2, '0');
    const ampm = hours >= 12 ? 'م' : 'ص';
    
    hours = hours % 12;
    hours = hours ? hours : 12;
    const hoursStr = hours.toString().padStart(2, '0');
    
    return `${hoursStr}:${minutes}:${seconds} ${ampm}`;
}

function updateClock() {
    const now = new Date();
    const systemLanguage = detectSystemLanguage();
    
    document.getElementById('clock-time').textContent = formatTime12Hour(now, currentTimezone);
    
    const timezoneInfo = timeZones[currentTimezone];
    const isSummer = checkSummerTime(now);
    const offset = isSummer ? timezoneInfo.summerOffset : timezoneInfo.offset;
    const offsetSign = offset >= 0 ? '+' : '';
    
    document.getElementById('clock-date').textContent = formatDateTime(now, systemLanguage);
    
    const seasonElement = document.getElementById('clock-season');
    const seasonText = document.getElementById('season-text');
    const timezoneInfoElement = document.getElementById('timezone-info');
    
    if (systemLanguage === 'ar') {
        seasonText.textContent = `توقيت ${timezoneInfo.city}`;
        timezoneInfoElement.textContent = `UTC${offsetSign}${offset}`;
        
        if (isSummer) {
            seasonElement.className = 'clock-season summer';
            seasonElement.innerHTML = `<i class="fas fa-sun"></i> <span>${seasonText.textContent} (صيفي)</span>`;
        } else {
            seasonElement.className = 'clock-season winter';
            seasonElement.innerHTML = `<i class="fas fa-snowflake"></i> <span>${seasonText.textContent}</span>`;
        }
    } else {
        seasonText.textContent = `${timezoneInfo.city} Time`;
        timezoneInfoElement.textContent = `UTC${offsetSign}${offset}`;
        
        if (isSummer) {
            seasonElement.className = 'clock-season summer';
            seasonElement.innerHTML = `<i class="fas fa-sun"></i> <span>${seasonText.textContent} (Summer)</span>`;
        } else {
            seasonElement.className = 'clock-season winter';
            seasonElement.innerHTML = `<i class="fas fa-snowflake"></i> <span>${seasonText.textContent}</span>`;
        }
    }
    
    const balanceUpdate = document.getElementById('balance-update-time');
    balanceUpdate.textContent = systemLanguage === 'ar' ? 
        `اليوم ${formatTime12Hour(now, currentTimezone)}` : 
        `Today ${formatTime12Hour(now, currentTimezone)}`;
}

setInterval(updateClock, 1000);
updateClock();

function changeTimezone(timezone) {
    currentTimezone = timezone;
    updateClock();
    showNotification(`تم تغيير التوقيت إلى ${timeZones[timezone].name}`, 'info');
}

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    
    let icon = 'fas fa-info-circle';
    if (type === 'success') icon = 'fas fa-check-circle';
    if (type === 'error') icon = 'fas fa-exclamation-circle';
    if (type === 'warning') icon = 'fas fa-exclamation-triangle';
    
    notification.innerHTML = `
        <i class="${icon}"></i>
        <span>${message}</span>
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 400);
    }, 5000);
}

function showLoading(show = true) {
    const loadingOverlay = document.getElementById('loading-overlay');
    if (show) {
        loadingOverlay.classList.add('active');
    } else {
        loadingOverlay.classList.remove('active');
    }
}

function toggleDarkMode() {
    document.body.classList.toggle('dark-mode');
    const themeToggle = document.getElementById('theme-toggle');
    const isDarkMode = document.body.classList.contains('dark-mode');
    
    if (isDarkMode) {
        themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
        localStorage.setItem('theme', 'dark');
        showNotification('تم تفعيل الوضع المظلم', 'info');
    } else {
        themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
        localStorage.setItem('theme', 'light');
        showNotification('تم تفعيل الوضع الفاتح', 'info');
    }
}

function switchSection(sectionId) {
    document.querySelectorAll('section').forEach(section => {
        section.classList.remove('active');
    });
    
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
    });
    
    document.getElementById(sectionId + '-section').classList.add('active');
    document.querySelector(`.nav-link[data-section="${sectionId}"]`).classList.add('active');
    
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function openSiteDetails(site) {
    const modal = document.getElementById('site-modal');
    const modalTitle = document.getElementById('modal-title');
    const modalBody = document.getElementById('modal-body');
    
    modalTitle.textContent = site.name;
    modalBody.innerHTML = `
        <div class="site-details">
            <div>
                <img src="${site.image}" alt="${site.name}">
            </div>
            <div class="site-details-info">
                <h4>الموقع:</h4>
                <p>${site.location}</p>
                
                <h4>العصر:</h4>
                <p>${site.era}</p>
                
                <h4>سعر التذكرة للأجانب:</h4>
                <p>${site.foreignPrice}</p>
                
                <h4>سعر التذكرة للمصريين:</h4>
                <p>${site.egyptianPrice}</p>
                
                <h4>مواعيد الزيارة:</h4>
                <p>${site.visitingHours}</p>
                
                <h4>الوصف:</h4>
                <p>${site.description}</p>
                
                <button class="btn book-from-modal" data-id="${site.id}" style="width: 100%; margin-top: 1rem;">
                    <i class="fas fa-ticket-alt"></i> احجز زيارة إلى ${site.name}
                </button>
            </div>
        </div>
    `;
    
    modalBody.querySelector('.book-from-modal').addEventListener('click', () => {
        modal.classList.remove('active');
        switchSection('booking');
        document.getElementById('site').value = site.id;
        calculatePrice();
        showNotification(`تم اختيار ${site.name} للحجز`, 'success');
    });
    
    modal.classList.add('active');
}

function openKingDetails(king) {
    const modal = document.getElementById('king-modal');
    const modalTitle = document.getElementById('king-modal-title');
    const modalBody = document.getElementById('king-modal-body');
    
    modalTitle.textContent = king.name;
    
    let achievementsList = '';
    king.achievements.forEach(achievement => {
        achievementsList += `<li>${achievement}</li>`;
    });
    
    modalBody.innerHTML = `
        <div class="site-details">
            <div>
                <img src="${king.image}" alt="${king.name}">
            </div>
            <div class="site-details-info">
                <h4>العصر:</h4>
                <p>${king.era}</p>
                
                <h4>فترة الحكم:</h4>
                <p>${king.reign}</p>
                
                <h4>مكان الدفن:</h4>
                <p>${king.burial}</p>
                
                <h4>الوصف:</h4>
                <p>${king.description}</p>
                
                <h4>أبرز الإنجازات:</h4>
                <ul>
                    ${achievementsList}
                </ul>
            </div>
        </div>
    `;
    
    modal.classList.add('active');
}

// ==================== نظام البحث المتقدم ====================
function initializeSearchSystem() {
    const searchInput = document.getElementById('search-input');
    const searchButton = document.getElementById('search-button');
    const searchResults = document.getElementById('search-results');
    
    const searchCategories = {
        sites: {
            name: "معالم أثرية",
            icon: "fas fa-landmark",
            color: "var(--primary-color)"
        },
        kings: {
            name: "ملوك مصر",
            icon: "fas fa-crown",
            color: "#FFD700"
        },
        wallet: {
            name: "المحفظة",
            icon: "fas fa-wallet",
            color: "#4CAF50"
        },
        booking: {
            name: "الحجز",
            icon: "fas fa-ticket-alt",
            color: "#2196F3"
        },
        quiz: {
            name: "اختبارات",
            icon: "fas fa-question-circle",
            color: "#FF9800"
        }
    };
    
    function performSearch(query) {
        if (!query.trim()) {
            searchResults.classList.remove('active');
            return;
        }
        
        const results = [];
        const lowerQuery = query.toLowerCase();
        
        archaeologicalSites.forEach(site => {
            if (site.name.toLowerCase().includes(lowerQuery) || 
                site.location.toLowerCase().includes(lowerQuery) ||
                site.description.toLowerCase().includes(lowerQuery) ||
                site.era.toLowerCase().includes(lowerQuery)) {
                results.push({
                    type: 'sites',
                    category: searchCategories.sites,
                    id: site.id,
                    name: site.name,
                    description: site.location,
                    action: "عرض التفاصيل",
                    data: site
                });
            }
        });
        
        egyptianKings.forEach(king => {
            if (king.name.toLowerCase().includes(lowerQuery) || 
                king.era.toLowerCase().includes(lowerQuery) ||
                king.description.toLowerCase().includes(lowerQuery) ||
                king.achievements.some(a => a.toLowerCase().includes(lowerQuery))) {
                results.push({
                    type: 'kings',
                    category: searchCategories.kings,
                    id: king.id,
                    name: king.name,
                    description: king.era,
                    action: "عرض التفاصيل",
                    data: king
                });
            }
        });
        
        if (lowerQuery.includes('رصيد') || lowerQuery.includes('محفظة') || 
            lowerQuery.includes('مال') || lowerQuery.includes('جنيه')) {
            results.push({
                type: 'wallet',
                category: searchCategories.wallet,
                id: 'wallet',
                name: "المحفظة الإلكترونية",
                description: "إدارة رصيدك وحمايته",
                action: "فتح المحفظة",
                data: null
            });
        }
        
        if (lowerQuery.includes('حجز') || lowerQuery.includes('تذكرة') || 
            lowerQuery.includes('رحلة') || lowerQuery.includes('زيارة')) {
            results.push({
                type: 'booking',
                category: searchCategories.booking,
                id: 'booking',
                name: "حجز رحلة",
                description: "احجز زيارتك للمعالم الأثرية",
                action: "فتح نموذج الحجز",
                data: null
            });
        }
        
        if (lowerQuery.includes('اختبار') || lowerQuery.includes('سؤال') || 
            lowerQuery.includes('تحدي') || lowerQuery.includes('ثقافة')) {
            results.push({
                type: 'quiz',
                category: searchCategories.quiz,
                id: 'quiz',
                name: "اختبارات وتحديات",
                description: "اختبر معلوماتك عن الحضارة الفرعونية",
                action: "فتح الاختبارات",
                data: null
            });
        }
        
        displaySearchResults(results);
    }
    
    function displaySearchResults(results) {
        searchResults.innerHTML = '';
        
        if (results.length === 0) {
            searchResults.innerHTML = `
                <div class="search-result-item" style="text-align: center; color: var(--secondary-color);">
                    <i class="fas fa-search"></i>
                    <div class="result-content">
                        <div class="result-name">لا توجد نتائج</div>
                        <div class="result-type">جرب كلمات بحث أخرى</div>
                    </div>
                </div>
            `;
            searchResults.classList.add('active');
            return;
        }
        
        results.forEach(result => {
            const resultElement = document.createElement('div');
            resultElement.className = 'search-result-item';
            resultElement.innerHTML = `
                <i class="${result.category.icon}" style="color: ${result.category.color}"></i>
                <div class="result-content">
                    <div class="result-name">${result.name}</div>
                    <div class="result-type">${result.category.name} - ${result.description}</div>
                </div>
                <div class="result-action">${result.action}</div>
            `;
            
            resultElement.addEventListener('click', () => {
                handleSearchResultClick(result);
                searchInput.value = '';
                searchResults.classList.remove('active');
            });
            
            searchResults.appendChild(resultElement);
        });
        
        const balance = parseInt(localStorage.getItem('walletBalance') || '0');
        if (balance > 0 && searchInput.value.toLowerCase().includes('رصيد')) {
            const balanceResult = document.createElement('div');
            balanceResult.className = 'balance-result';
            balanceResult.innerHTML = `
                <div class="balance-label">رصيدك الحالي</div>
                <div class="balance-amount">${balance} جنيه</div>
                <div class="balance-label">في المحفظة الإلكترونية</div>
            `;
            searchResults.appendChild(balanceResult);
        }
        
        searchResults.classList.add('active');
    }
    
    function handleSearchResultClick(result) {
        switch(result.type) {
            case 'sites':
                openSiteDetails(result.data);
                break;
            case 'kings':
                openKingDetails(result.data);
                break;
            case 'wallet':
                switchSection('wallet');
                showNotification('تم فتح قسم المحفظة', 'info');
                break;
            case 'booking':
                switchSection('booking');
                showNotification('تم فتح نموذج الحجز', 'info');
                break;
            case 'quiz':
                switchSection('challenges');
                showNotification('تم فتح قسم الاختبارات والتحديات', 'info');
                break;
        }
    }
    
    searchInput.addEventListener('input', function() {
        performSearch(this.value);
    });
    
    searchButton.addEventListener('click', function() {
        performSearch(searchInput.value);
    });
    
    searchInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            performSearch(this.value);
        }
    });
    
    document.addEventListener('click', function(e) {
        if (!searchContainer.contains(e.target)) {
            searchResults.classList.remove('active');
        }
    });
    
    const urlParams = new URLSearchParams(window.location.search);
    const searchParam = urlParams.get('search');
    if (searchParam) {
        searchInput.value = decodeURIComponent(searchParam);
        performSearch(searchParam);
    }
}

// ==================== عرض المعالم الأثرية ====================
function displaySites() {
    const sitesContainer = document.getElementById('sites-container');
    const siteSelect = document.getElementById('site');
    
    sitesContainer.innerHTML = '';
    siteSelect.innerHTML = '<option value="">-- اختر المعلم الأثري --</option>';
    
    archaeologicalSites.forEach(site => {
        const siteCard = document.createElement('div');
        siteCard.className = 'site-card';
        siteCard.innerHTML = `
            <div class="site-image" style="background-image: url('${site.image}')">
                <div class="site-overlay">
                    <h3>${site.name}</h3>
                </div>
            </div>
            <div class="site-info">
                <div class="site-meta">
                    <span class="site-location">
                        <i class="fas fa-map-marker-alt"></i> ${site.location}
                    </span>
                    <span class="site-price">
                        <i class="fas fa-ticket-alt"></i> ${site.foreignPrice}
                    </span>
                </div>
                <p class="site-description">${site.description}</p>
                <div class="site-hours">
                    <i class="far fa-clock"></i> ${site.visitingHours}
                </div>
                <div class="site-links">
                    <a href="#" class="site-link book-site" data-id="${site.id}">
                        <i class="fas fa-ticket-alt"></i> احجز الآن
                    </a>
                    <a href="#" class="site-link view-details" data-id="${site.id}">
                        <i class="fas fa-info-circle"></i> التفاصيل
                    </a>
                </div>
            </div>
        `;
        
        siteCard.querySelector('.view-details').addEventListener('click', (e) => {
            e.preventDefault();
            openSiteDetails(site);
        });
        
        siteCard.querySelector('.book-site').addEventListener('click', (e) => {
            e.preventDefault();
            switchSection('booking');
            document.getElementById('site').value = site.id;
            calculatePrice();
            showNotification(`تم اختيار ${site.name} للحجز`, 'success');
        });
        
        sitesContainer.appendChild(siteCard);
        
        const option = document.createElement('option');
        option.value = site.id;
        option.textContent = site.name;
        option.setAttribute('data-price', site.basePrice);
        option.setAttribute('data-egyptian-price', site.egyptianBasePrice);
        siteSelect.appendChild(option);
    });
}

// ==================== عرض ملوك مصر ====================
function displayKings() {
    const kingsContainer = document.getElementById('kings-container');
    
    kingsContainer.innerHTML = '';
    
    egyptianKings.forEach(king => {
        const kingCard = document.createElement('div');
        kingCard.className = 'site-card';
        kingCard.innerHTML = `
            <div class="site-image" style="background-image: url('${king.image}')">
                <div class="site-overlay">
                    <h3>${king.name}</h3>
                </div>
            </div>
            <div class="site-info">
                <div class="site-meta">
                    <span class="site-location">
                        <i class="fas fa-history"></i> ${king.era}
                    </span>
                    <span class="site-price">
                        <i class="fas fa-calendar-alt"></i> ${king.reign}
                    </span>
                </div>
                <p class="site-description">${king.description}</p>
                <div class="site-hours">
                    <i class="fas fa-monument"></i> مكان الدفن: ${king.burial}
                </div>
                <div class="site-links">
                    <a href="#" class="site-link view-king-details" data-id="${king.id}">
                        <i class="fas fa-info-circle"></i> التفاصيل
                    </a>
                </div>
            </div>
        `;
        
        kingCard.querySelector('.view-king-details').addEventListener('click', (e) => {
            e.preventDefault();
            openKingDetails(king);
        });
        
        kingsContainer.appendChild(kingCard);
    });
}

// ==================== نظام الحجز المتقدم ====================
function initializeBookingSystem() {
    const bookingForm = document.getElementById('booking-form');
    const siteSelect = document.getElementById('site');
    const visitorsInput = document.getElementById('visitors');
    const visitorTypeEgyptian = document.getElementById('visitor-type-egyptian');
    const visitorTypeForeign = document.getElementById('visitor-type-foreign');
    
    function updatePrice() {
        calculatePrice();
    }
    
    siteSelect.addEventListener('change', updatePrice);
    visitorsInput.addEventListener('input', updatePrice);
    visitorTypeEgyptian.addEventListener('change', updatePrice);
    visitorTypeForeign.addEventListener('change', updatePrice);
    
    document.querySelectorAll('.service-item input').forEach(checkbox => {
        checkbox.addEventListener('change', updatePrice);
    });
    
    bookingForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const bookingName = document.getElementById('booking-name').value;
        const bookingPhone = document.getElementById('booking-phone').value;
        const nationalId = document.getElementById('national-id').value;
        const siteId = siteSelect.value;
        const visitors = visitorsInput.value;
        const date = document.getElementById('date').value;
        
        if (!bookingName || !bookingPhone || !nationalId || !siteId || !visitors || !date) {
            showNotification('يرجى ملء جميع الحقول المطلوبة', 'error');
            return;
        }
        
        const selectedSite = archaeologicalSites.find(s => s.id == siteId);
        const visitorType = document.querySelector('input[name="visitor-type"]:checked').value;
        const isEgyptian = visitorType === 'egyptian';
        
        const totalPrice = calculatePrice(true);
        
        showPaymentProcess('wallet', totalPrice, 
            () => {
                showLoading(true);
                setTimeout(() => {
                    showLoading(false);
                    
                    // خصم المبلغ من المحفظة
                    const currentBalance = parseInt(document.getElementById('balance-amount-main').textContent) || 0;
                    if (currentBalance >= totalPrice) {
                        // خصم المبلغ تلقائياً
                        let balance = parseInt(localStorage.getItem('walletBalance') || '0');
                        balance -= totalPrice;
                        localStorage.setItem('walletBalance', balance);
                        document.getElementById('balance-amount-main').textContent = `${balance} جنيه`;
                        
                        // إضافة معاملة للتاريخ
                        const transactionItem = document.createElement('div');
                        transactionItem.className = 'transaction-item';
                        transactionItem.innerHTML = `
                            <span>حجز رحلة إلى ${selectedSite.name}</span>
                            <span class="transaction-amount negative">-${totalPrice} جنيه</span>
                        `;
                        document.getElementById('transaction-list').insertBefore(transactionItem, document.getElementById('transaction-list').firstChild);
                        
                        const bookingNumber = 'SPHX-' + Date.now().toString().slice(-8);
                        
                        const receipt = `
                            <div class="payment-receipt">
                                <h3><i class="fas fa-receipt"></i> إيصال الحجز</h3>
                                <div class="receipt-item">
                                    <span>رقم الحجز:</span>
                                    <span>${bookingNumber}</span>
                                </div>
                                <div class="receipt-item">
                                    <span>اسم صاحب الحجز:</span>
                                    <span>${bookingName}</span>
                                </div>
                                <div class="receipt-item">
                                    <span>رقم صاحب الحجز:</span>
                                    <span>${bookingPhone}</span>
                                </div>
                                <div class="receipt-item">
                                    <span>الرقم القومي:</span>
                                    <span>${nationalId}</span>
                                </div>
                                <div class="receipt-item">
                                    <span>المعلم الأثري:</span>
                                    <span>${selectedSite.name}</span>
                                </div>
                                <div class="receipt-item">
                                    <span>تاريخ الزيارة:</span>
                                    <span>${date}</span>
                                </div>
                                <div class="receipt-item">
                                    <span>عدد الزوار:</span>
                                    <span>${visitors}</span>
                                </div>
                                <div class="receipt-item">
                                    <span>نوع الزائر:</span>
                                    <span>${isEgyptian ? 'زائر مصري' : 'زائر أجنبي'}</span>
                                </div>
                                <div class="receipt-item receipt-total">
                                    <span>المبلغ المدفوع:</span>
                                    <span>${totalPrice} جنيه</span>
                                </div>
                                <div style="margin-top: 15px; padding: 10px; background-color: rgba(184, 148, 46, 0.05); border-radius: 5px; font-size: 0.85rem; text-align: center;">
                                    <i class="fas fa-info-circle"></i> سيتم إرسال تأكيد الحجز مع الرقم المرجعي إلى رقم الهاتف المقدم
                                </div>
                            </div>
                        `;
                        
                        document.getElementById('payment-process-content').innerHTML = `
                            <div class="payment-success">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <h3>تمت عملية الحجز بنجاح!</h3>
                            <p>رقم حجزك: <strong>${bookingNumber}</strong></p>
                            ${receipt}
                            <div class="payment-actions">
                                <button class="btn" id="confirm-booking-btn">
                                    <i class="fas fa-check-double"></i> تأكيد الحجز
                                </button>
                                <button class="btn" id="print-receipt">
                                    <i class="fas fa-print"></i> طباعة الإيصال
                                </button>
                                <button class="btn" id="new-booking">
                                    <i class="fas fa-plus"></i> حجز جديد
                                </button>
                            </div>
                        `;
                        
                        document.getElementById('confirm-booking-btn').addEventListener('click', () => {
                            showNotification('تم تأكيد الحجز بنجاح!', 'success');
                            setTimeout(() => {
                                bookingForm.reset();
                                document.getElementById('payment-process').classList.remove('active');
                                calculatePrice();
                            }, 2000);
                        });
                        
                        document.getElementById('print-receipt').addEventListener('click', () => {
                            window.print();
                        });
                        
                        document.getElementById('new-booking').addEventListener('click', () => {
                            bookingForm.reset();
                            document.getElementById('payment-process').classList.remove('active');
                            calculatePrice();
                        });
                        
                        showNotification(`تم تأكيد حجزك بنجاح! رقم الحجز: ${bookingNumber}`, 'success');
                    } else {
                        document.getElementById('payment-process-content').innerHTML = `
                            <div class="payment-failure">
                                <i class="fas fa-times-circle"></i>
                            </div>
                            <h3>رصيد غير كافي</h3>
                            <p>رصيدك الحالي: ${currentBalance} جنيه</p>
                            <p>المبلغ المطلوب: ${totalPrice} جنيه</p>
                            <div class="payment-actions">
                                <button class="btn" id="add-funds-now">
                                    <i class="fas fa-plus-circle"></i> إضافة رصيد
                                </button>
                                <button class="btn" id="change-payment-method">
                                    <i class="fas fa-exchange-alt"></i> تغيير طريقة الدفع
                                </button>
                            </div>
                        `;
                        
                        document.getElementById('add-funds-now').addEventListener('click', () => {
                            switchSection('wallet');
                            document.getElementById('payment-process').classList.remove('active');
                        });
                        
                        document.getElementById('change-payment-method').addEventListener('click', () => {
                            document.getElementById('payment-process').classList.remove('active');
                        });
                        
                        showNotification('رصيدك غير كافي لإتمام عملية الحجز', 'error');
                    }
                }, 2000);
            },
            () => {
                document.getElementById('payment-process-content').innerHTML = `
                    <div class="payment-failure">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <h3>فشلت عملية الدفع</h3>
                    <p>يرجى المحاولة مرة أخرى أو استخدام طريقة دفع أخرى</p>
                    <div class="payment-actions">
                        <button class="btn" id="retry-payment">
                            <i class="fas fa-redo"></i> إعادة المحاولة
                        </button>
                        <button class="btn" id="change-payment-method">
                            <i class="fas fa-exchange-alt"></i> تغيير طريقة الدفع
                        </button>
                    </div>
                `;
                
                showNotification('فشلت عملية الدفع', 'error');
            }
        );
    });
}

// ==================== حساب السعر المتقدم ====================
function calculatePrice(returnTotal = false) {
    const siteSelect = document.getElementById('site');
    const selectedOption = siteSelect.options[siteSelect.selectedIndex];
    const visitors = parseInt(document.getElementById('visitors').value) || 0;
    const isEgyptian = document.getElementById('visitor-type-egyptian').checked;
    
    let basePrice = 0;
    if (selectedOption) {
        if (isEgyptian) {
            basePrice = parseInt(selectedOption.getAttribute('data-egyptian-price')) || 0;
            document.getElementById('ticket-price-per-person').textContent = `${basePrice} جنيه (مصري)`;
        } else {
            basePrice = parseInt(selectedOption.getAttribute('data-price')) || 0;
            document.getElementById('ticket-price-per-person').textContent = `${basePrice} جنيه (أجنبي)`;
        }
    }
    
    let servicesPrice = 0;
    const serviceCheckboxes = document.querySelectorAll('.service-item input[type="checkbox"]');
    serviceCheckboxes.forEach(checkbox => {
        if (checkbox.checked) {
            let serviceValue = parseInt(checkbox.value);
            if (checkbox.id === 'lunch') {
                serviceValue *= visitors;
            }
            servicesPrice += serviceValue;
        }
    });
    
    const totalTicketPrice = basePrice * visitors;
    const totalPrice = totalTicketPrice + servicesPrice;
    
    document.getElementById('visitors-count').textContent = visitors;
    document.getElementById('ticket-price-total').textContent = `${totalTicketPrice} جنيه`;
    document.getElementById('services-price').textContent = `${servicesPrice} جنيه`;
    document.getElementById('total-price').textContent = `${totalPrice} جنيه`;
    
    updateInstallmentOptions(totalPrice);
    
    const balanceAmount = document.getElementById('balance-amount-main');
    const currentBalance = parseInt(balanceAmount.textContent) || 0;
    const submitButton = document.getElementById('submit-booking');
    
    if (totalPrice > 0 && totalPrice > currentBalance) {
        submitButton.disabled = true;
        submitButton.title = "رصيدك غير كافي لإتمام عملية الحجز";
    } else {
        submitButton.disabled = false;
        submitButton.title = "";
    }
    
    if (returnTotal) {
        return totalPrice;
    }
}

function updateInstallmentOptions(totalPrice) {
    if (totalPrice <= 0) return;
    
    const installment3 = Math.ceil(totalPrice / 3);
    const installment6 = Math.ceil(totalPrice / 6);
    const installment12 = Math.ceil(totalPrice / 12);
    
    document.getElementById('installment-amount-1').textContent = `${totalPrice} جنيه`;
    document.getElementById('installment-amount-3').textContent = `${installment3} جنيه/شهر`;
    document.getElementById('installment-amount-6').textContent = `${installment6} جنيه/شهر`;
    document.getElementById('installment-amount-12').textContent = `${installment12} جنيه/شهر`;
}

// ==================== نظام الدفع التفاعلي ====================
function showPaymentProcess(method, amount, onSuccess, onFailure) {
    const paymentProcess = document.getElementById('payment-process');
    const paymentProcessContent = document.getElementById('payment-process-content');
    
    paymentProcess.classList.add('active');
    
    updatePaymentStep(1);
    paymentProcessContent.innerHTML = `
        <h3>تأكيد عملية الدفع</h3>
        <p>المبلغ: <strong>${amount} جنيه</strong></p>
        <p>طريقة الدفع: <strong>${getPaymentMethodName(method)}</strong></p>
        <div class="payment-actions">
            <button class="btn" id="confirm-payment">
                <i class="fas fa-check"></i> تأكيد الدفع
            </button>
            <button class="btn" id="cancel-payment">
                <i class="fas fa-times"></i> إلغاء
            </button>
        </div>
    `;
    
    document.getElementById('confirm-payment').addEventListener('click', () => {
        updatePaymentStep(2);
        paymentProcessContent.innerHTML = `
            <div class="payment-processing">
                <div class="processing-spinner"></div>
                <h3>جارٍ معالجة الدفع...</h3>
                <p>يرجى الانتظار قليلاً</p>
            </div>
        `;
        
        setTimeout(() => {
            updatePaymentStep(3);
            
            if (Math.random() < 0.9) {
                onSuccess();
            } else {
                onFailure();
            }
        }, 3000);
    });
    
    document.getElementById('cancel-payment').addEventListener('click', () => {
        paymentProcess.classList.remove('active');
        showNotification('تم إلغاء عملية الدفع', 'info');
    });
}

function updatePaymentStep(step) {
    document.querySelectorAll('.payment-step').forEach((stepEl, index) => {
        stepEl.classList.remove('active', 'completed');
        if (index + 1 < step) {
            stepEl.classList.add('completed');
        } else if (index + 1 === step) {
            stepEl.classList.add('active');
        }
    });
}

function getPaymentMethodName(method) {
    const methods = {
        'wallet': 'المحفظة الإلكترونية',
        'visa': 'بطاقة فيزا',
        'mastercard': 'ماستركارد',
        'paypal': 'باي بال',
        'mada': 'مدى',
        'applepay': 'آبل باي',
        'googlepay': 'جوجل باي',
        'stcpay': 'STC Pay',
        'banktransfer': 'تحويل بنكي',
        'vodafonecash': 'فودافون كاش',
        'orangecash': 'أورانج كاش',
        'etisalatcash': 'اتصالات كاش'
    };
    return methods[method] || method;
}

// ==================== نظام المحفظة الإلكترونية ====================
function initializeWalletMain() {
    const addFundsBtn = document.getElementById('add-funds-main');
    const withdrawFundsBtn = document.getElementById('withdraw-funds-main');
    const transactionHistoryBtn = document.getElementById('transaction-history-main');
    const setupPasswordBtn = document.getElementById('setup-password-main');
    const changePasswordBtn = document.getElementById('change-password-main');
    const resetBalanceBtn = document.getElementById('reset-balance-main');
    const balanceAmount = document.getElementById('balance-amount-main');
    const transactionList = document.getElementById('transaction-list');
    
    let balance = 0;
    let walletPassword = null;
    let securityQuestion = null;
    let securityAnswer = null;
    
    const savedBalance = localStorage.getItem('walletBalance');
    const savedPassword = localStorage.getItem('walletPassword');
    const savedSecurityQuestion = localStorage.getItem('walletSecurityQuestion');
    const savedSecurityAnswer = localStorage.getItem('walletSecurityAnswer');
    
    if (savedBalance) {
        balance = parseInt(savedBalance);
        updateBalance();
    }
    
    if (savedPassword && savedSecurityQuestion && savedSecurityAnswer) {
        walletPassword = savedPassword;
        securityQuestion = savedSecurityQuestion;
        securityAnswer = savedSecurityAnswer;
        updateSecurityStatus(true);
    } else {
        updateSecurityStatus(false);
    }
    
    function updateBalance() {
        balanceAmount.textContent = `${balance} جنيه`;
        localStorage.setItem('walletBalance', balance);
        calculatePrice();
    }
    
    function addTransaction(description, amount, type) {
        const transactionItem = document.createElement('div');
        transactionItem.className = 'transaction-item';
        
        const amountClass = type === 'positive' ? 'positive' : 'negative';
        const amountSign = type === 'positive' ? '+' : '-';
        
        transactionItem.innerHTML = `
            <span>${description}</span>
            <span class="transaction-amount ${amountClass}">${amountSign}${amount} جنيه</span>
        `;
        
        transactionList.insertBefore(transactionItem, transactionList.firstChild);
    }
    
    addFundsBtn.addEventListener('click', () => {
        const amount = prompt("أدخل المبلغ الذي تريد إضافته:");
        if (amount && !isNaN(amount) && amount > 0) {
            if (walletPassword) {
                showPasswordVerification('إضافة رصيد', `يرجى إدخال كلمة مرور المحفظة للموافقة على إضافة ${amount} جنيه`, () => {
                    balance += parseInt(amount);
                    updateBalance();
                    showNotification(`تم إضافة ${amount} جنيه إلى رصيدك بنجاح!`, 'success');
                    addTransaction(`إضافة رصيد`, parseInt(amount), 'positive');
                });
            } else {
                balance += parseInt(amount);
                updateBalance();
                showNotification(`تم إضافة ${amount} جنيه إلى رصيدك بنجاح!`, 'success');
                addTransaction(`إضافة رصيد`, parseInt(amount), 'positive');
            }
        } else {
            showNotification("يرجى إدخال مبلغ صحيح", 'error');
        }
    });
    
    withdrawFundsBtn.addEventListener('click', () => {
        const amount = prompt("أدخل المبلغ الذي تريد سحبه:");
        if (amount && !isNaN(amount) && amount > 0) {
            if (parseInt(amount) <= balance) {
                if (walletPassword) {
                    showPasswordVerification('سحب رصيد', `يرجى إدخال كلمة مرور المحفظة للموافقة على سحب ${amount} جنيه`, () => {
                        balance -= parseInt(amount);
                        updateBalance();
                        showNotification(`تم سحب ${amount} جنيه من رصيدك بنجاح!`, 'success');
                        addTransaction(`سحب رصيد`, parseInt(amount), 'negative');
                    });
                } else {
                    balance -= parseInt(amount);
                    updateBalance();
                    showNotification(`تم سحب ${amount} جنيه من رصيدك بنجاح!`, 'success');
                    addTransaction(`سحب رصيد`, parseInt(amount), 'negative');
                }
            } else {
                showNotification("رصيدك غير كافي", 'error');
            }
        } else {
            showNotification("يرجى إدخال مبلغ صحيح", 'error');
        }
    });
    
    function updateSecurityStatus(hasPassword) {
        const securityStatus = document.getElementById('security-status');
        const changePasswordBtn = document.getElementById('change-password-main');
        
        if (hasPassword) {
            securityStatus.className = 'security-status active';
            securityStatus.innerHTML = `
                <i class="fas fa-shield-alt"></i>
                <div>
                    <div>حماية المحفظة: <strong>مفعلة</strong></div>
                    <div style="font-size: 0.85rem; opacity: 0.8;">محفظتك محمية بكلمة مرور</div>
                </div>
            `;
            changePasswordBtn.style.display = 'block';
        } else {
            securityStatus.className = 'security-status inactive';
            securityStatus.innerHTML = `
                <i class="fas fa-shield-alt"></i>
                <div>
                    <div>حماية المحفظة: <strong>غير مفعلة</strong></div>
                    <div style="font-size: 0.85rem; opacity: 0.8;">أنشئ كلمة مرور لحماية أموالك</div>
                </div>
            `;
            changePasswordBtn.style.display = 'none';
        }
    }
    
    function showPasswordVerification(title, message, onSuccess) {
        document.getElementById('password-verify-title').textContent = title;
        document.getElementById('password-verify-message').textContent = message;
        document.getElementById('verify-password').value = '';
        document.getElementById('password-error').style.display = 'none';
        
        const modal = document.getElementById('password-verify-modal');
        modal.classList.add('active');
        
        const verifyHandler = function() {
            const password = document.getElementById('verify-password').value;
            
            if (password === walletPassword) {
                modal.classList.remove('active');
                onSuccess();
            } else {
                document.getElementById('password-error').style.display = 'block';
            }
        };
        
        document.getElementById('verify-password-btn').onclick = verifyHandler;
        
        document.getElementById('verify-password').onkeypress = function(e) {
            if (e.key === 'Enter') {
                verifyHandler();
            }
        };
    }
    
    setupPasswordBtn.addEventListener('click', () => {
        document.getElementById('password-setup-modal').classList.add('active');
    });
    
    document.getElementById('setup-password-btn').addEventListener('click', function() {
        const newPassword = document.getElementById('new-password').value;
        const confirmPassword = document.getElementById('confirm-password').value;
        const question = document.getElementById('security-question').value;
        const answer = document.getElementById('security-answer').value;
        
        if (!newPassword) {
            document.getElementById('password-setup-modal').classList.remove('active');
            showNotification('تم تخطي إنشاء كلمة المرور', 'info');
            return;
        }
        
        if (newPassword !== confirmPassword) {
            showNotification('كلمتا المرور غير متطابقتين', 'error');
            return;
        }
        
        if (newPassword.length < 4) {
            showNotification('كلمة المرور يجب أن تحتوي على 4 أحرف على الأقل', 'error');
            return;
        }
        
        walletPassword = newPassword;
        securityQuestion = question;
        securityAnswer = answer.toLowerCase().trim();
        
        localStorage.setItem('walletPassword', walletPassword);
        localStorage.setItem('walletSecurityQuestion', securityQuestion);
        localStorage.setItem('walletSecurityAnswer', securityAnswer);
        
        document.getElementById('password-setup-modal').classList.remove('active');
        showNotification('تم إنشاء كلمة مرور المحفظة بنجاح', 'success');
        updateSecurityStatus(true);
        
        document.getElementById('new-password').value = '';
        document.getElementById('confirm-password').value = '';
        document.getElementById('security-question').value = '';
        document.getElementById('security-answer').value = '';
    });
    
    document.getElementById('skip-password-btn').addEventListener('click', function() {
        document.getElementById('password-setup-modal').classList.remove('active');
        showNotification('تم تخطي إنشاء كلمة المرور', 'info');
    });
    
    changePasswordBtn.addEventListener('click', function() {
        if (!walletPassword) {
            showNotification('لا توجد كلمة مرور مسبقة للمحفظة', 'error');
            return;
        }
        document.getElementById('change-password-modal').classList.add('active');
    });
    
    document.getElementById('change-password-btn').addEventListener('click', function() {
        const currentPassword = document.getElementById('current-password').value;
        const newPassword = document.getElementById('new-password-change').value;
        const confirmPassword = document.getElementById('confirm-password-change').value;
        
        if (currentPassword !== walletPassword) {
            document.getElementById('change-password-error').style.display = 'block';
            return;
        }
        
        if (newPassword !== confirmPassword) {
            showNotification('كلمتا المرور غير متطابقتين', 'error');
            return;
        }
        
        if (newPassword.length < 4) {
            showNotification('كلمة المرور يجب أن تحتوي على 4 أحرف على الأقل', 'error');
            return;
        }
        
        walletPassword = newPassword;
        localStorage.setItem('walletPassword', walletPassword);
        
        document.getElementById('change-password-modal').classList.remove('active');
        showNotification('تم تغيير كلمة مرور المحفظة بنجاح', 'success');
        
        document.getElementById('current-password').value = '';
        document.getElementById('new-password-change').value = '';
        document.getElementById('confirm-password-change').value = '';
    });
    
    document.getElementById('remove-password-btn').addEventListener('click', function() {
        if (confirm('هل أنت متأكد من إزالة كلمة المرور؟ المحفظة لن تكون محمية بعد الآن.')) {
            walletPassword = null;
            securityQuestion = null;
            securityAnswer = null;
            
            localStorage.removeItem('walletPassword');
            localStorage.removeItem('walletSecurityQuestion');
            localStorage.removeItem('walletSecurityAnswer');
            
            document.getElementById('change-password-modal').classList.remove('active');
            showNotification('تم إزالة كلمة مرور المحفظة بنجاح', 'success');
            updateSecurityStatus(false);
        }
    });
    
    document.getElementById('forgot-password-link').addEventListener('click', function(e) {
        e.preventDefault();
        
        if (!securityQuestion) {
            showNotification('لم يتم تعيين سؤال أمان للمحفظة', 'error');
            return;
        }
        
        document.getElementById('password-verify-modal').classList.remove('active');
        document.getElementById('password-recovery-modal').classList.add('active');
        document.getElementById('recovery-question').textContent = securityQuestion;
    });
    
    document.getElementById('verify-recovery-btn').addEventListener('click', function() {
        const answer = document.getElementById('recovery-answer').value.toLowerCase().trim();
        
        if (answer === securityAnswer) {
            document.getElementById('password-recovery-modal').classList.remove('active');
            showNotification('تم التحقق بنجاح! يمكنك الآن الوصول إلى المحفظة', 'success');
        } else {
            document.getElementById('recovery-error').style.display = 'block';
        }
    });
    
    resetBalanceBtn.addEventListener('click', function() {
        document.getElementById('reset-balance-modal').classList.add('active');
    });
    
    document.getElementById('confirm-reset-btn').addEventListener('click', function() {
        const confirmText = document.getElementById('reset-confirm').value;
        
        if (confirmText === 'نعم') {
            if (walletPassword) {
                document.getElementById('reset-balance-modal').classList.remove('active');
                showPasswordVerification('إعادة تعيين الرصيد', 'يرجى إدخال كلمة مرور المحفظة للموافقة على إعادة تعيين الرصيد', () => {
                    balance = 0;
                    updateBalance();
                    showNotification('تم إعادة تعيين رصيد المحفظة بنجاح', 'success');
                    addTransaction('إعادة تعيين الرصيد', 0, 'negative');
                });
            } else {
                balance = 0;
                updateBalance();
                document.getElementById('reset-balance-modal').classList.remove('active');
                showNotification('تم إعادة تعيين رصيد المحفظة بنجاح', 'success');
                addTransaction('إعادة تعيين الرصيد', 0, 'negative');
            }
        } else {
            document.getElementById('reset-error').style.display = 'block';
        }
    });
    
    document.getElementById('cancel-reset-btn').addEventListener('click', function() {
        document.getElementById('reset-balance-modal').classList.remove('active');
    });
    
    return {
        getBalance: () => balance,
        updateBalance: updateBalance
    };
}

// ==================== نظام الاختبارات الثقافية ====================
let currentQuiz = null;
let currentQuestionIndex = 0;
let userScore = 0;
let timer = null;
let timeLeft = 30;
let userAnswers = [];
let currentQuizQuestions = [];

function initializeQuizSystem() {
    const challengesContainer = document.getElementById('challenges-container');
    
    const challengeLevels = [
        { level: 1, name: "مبتدئ", description: "10 أسئلة سهلة عن مصر القديمة", points: 100, color: "#4CAF50" },
        { level: 2, name: "متوسط", description: "15 سؤالاً متوسط الصعوبة", points: 250, color: "#FF9800" },
        { level: 3, name: "متقدم", description: "20 سؤالاً صعباً عن الحضارة الفرعونية", points: 500, color: "#f44336" }
    ];
    
    challengesContainer.innerHTML = '';
    
    challengeLevels.forEach(challenge => {
        const challengeCard = document.createElement('div');
        challengeCard.className = 'challenge-card';
        challengeCard.innerHTML = `
            <div class="challenge-header">
                <h3>اختبار المستوى ${challenge.level}</h3>
                <div class="challenge-level" style="background-color: ${challenge.color}">${challenge.name}</div>
            </div>
            <div class="challenge-body">
                <p class="challenge-description">${challenge.description}</p>
                <div class="challenge-stats">
                    <span><i class="fas fa-question-circle"></i> ${challenge.level === 1 ? '10' : challenge.level === 2 ? '15' : '20'} سؤال</span>
                    <span><i class="fas fa-clock"></i> ${challenge.level === 1 ? '15' : challenge.level === 2 ? '25' : '30'} دقيقة</span>
                </div>
                <div class="challenge-reward">
                    <i class="fas fa-trophy"></i>
                    <span>${challenge.points} نقطة</span>
                </div>
                <button class="btn start-quiz-btn" data-level="${challenge.level}" style="width: 100%; margin-top: 1rem;">
                    <i class="fas fa-play"></i> بدء الاختبار
                </button>
            </div>
        `;
        
        challengeCard.querySelector('.start-quiz-btn').addEventListener('click', function() {
            startQuiz(challenge.level);
        });
        
        challengesContainer.appendChild(challengeCard);
    });
}

function startQuiz(level) {
    currentQuiz = level;
    currentQuestionIndex = 0;
    userScore = 0;
    userAnswers = [];
    
    let filteredQuestions = quizQuestions.filter(q => q.level === level);
    
    let questionCount = level === 1 ? 10 : level === 2 ? 15 : 20;
    filteredQuestions = filteredQuestions.slice(0, questionCount);
    
    currentQuizQuestions = filteredQuestions;
    
    showQuizInterface();
    showQuestion(currentQuestionIndex);
    
    startTimer(level === 1 ? 900 : level === 2 ? 1500 : 1800);
}

function showQuizInterface() {
    const quizContainer = document.getElementById('quiz-container');
    quizContainer.innerHTML = `
        <div class="quiz-header">
            <h3>اختبار المستوى ${currentQuiz}</h3>
            <div class="question-counter">
                <span id="current-question">1</span>/<span id="total-questions">${currentQuizQuestions.length}</span>
            </div>
        </div>
        <div class="quiz-stats">
            <div class="stat-item">
                <div class="stat-value" id="current-score">0</div>
                <div class="stat-label">النقاط</div>
            </div>
            <div class="stat-item">
                <div class="timer-display" id="quiz-timer">30:00</div>
                <div class="stat-label">الوقت المتبقي</div>
            </div>
            <div class="stat-item">
                <div class="stat-value" id="correct-answers">0</div>
                <div class="stat-label">الإجابات الصحيحة</div>
            </div>
        </div>
        <div class="quiz-progress">
            <div class="quiz-progress-bar" id="quiz-progress-bar" style="width: 0%"></div>
        </div>
        <div class="quiz-question" id="quiz-question"></div>
        <div class="quiz-options" id="quiz-options"></div>
        <div class="quiz-actions">
            <button class="btn" id="prev-question" disabled>
                <i class="fas fa-arrow-right"></i> السابق
            </button>
            <button class="btn" id="next-question">
                التالي <i class="fas fa-arrow-left"></i>
            </button>
        </div>
    `;
    
    quizContainer.classList.add('active');
    
    document.getElementById('prev-question').addEventListener('click', () => {
        if (currentQuestionIndex > 0) {
            currentQuestionIndex--;
            showQuestion(currentQuestionIndex);
        }
    });
    
    document.getElementById('next-question').addEventListener('click', () => {
        if (currentQuestionIndex < currentQuizQuestions.length - 1) {
            currentQuestionIndex++;
            showQuestion(currentQuestionIndex);
        } else {
            finishQuiz();
        }
    });
}

function showQuestion(index) {
    const question = currentQuizQuestions[index];
    
    document.getElementById('current-question').textContent = index + 1;
    document.getElementById('total-questions').textContent = currentQuizQuestions.length;
    
    const progress = ((index) / currentQuizQuestions.length) * 100;
    document.getElementById('quiz-progress-bar').style.width = `${progress}%`;
    
    document.getElementById('quiz-question').textContent = question.question;
    
    const optionsContainer = document.getElementById('quiz-options');
    optionsContainer.innerHTML = '';
    
    question.options.forEach((option, optionIndex) => {
        const optionElement = document.createElement('div');
        optionElement.className = 'quiz-option';
        optionElement.textContent = option;
        optionElement.dataset.index = optionIndex;
        
        if (userAnswers[index] !== undefined) {
            if (userAnswers[index] === optionIndex) {
                optionElement.classList.add('selected');
                if (userAnswers[index] === question.correct) {
                    optionElement.classList.add('correct');
                } else {
                    optionElement.classList.add('incorrect');
                    const correctOption = document.createElement('div');
                    correctOption.className = 'quiz-option correct';
                    correctOption.textContent = question.options[question.correct];
                    correctOption.style.marginTop = '10px';
                    correctOption.style.opacity = '0.8';
                    optionsContainer.appendChild(correctOption);
                }
            }
        }
        
        optionElement.addEventListener('click', () => {
            if (userAnswers[index] === undefined) {
                userAnswers[index] = optionIndex;
                
                if (optionIndex === question.correct) {
                    userScore += question.points;
                    optionElement.classList.add('correct');
                    showNotification(`إجابة صحيحة! +${question.points} نقطة`, 'success');
                } else {
                    optionElement.classList.add('incorrect');
                    showNotification(`إجابة خاطئة! الإجابة الصحيحة: ${question.options[question.correct]}`, 'error');
                }
                
                optionElement.classList.add('selected');
                
                updateQuizStats();
            }
        });
        
        optionsContainer.appendChild(optionElement);
    });
    
    document.getElementById('prev-question').disabled = index === 0;
    document.getElementById('next-question').textContent = index === currentQuizQuestions.length - 1 ? 'إنهاء الاختبار' : 'التالي';
    document.getElementById('next-question').innerHTML = index === currentQuizQuestions.length - 1 ? 
        'إنهاء الاختبار <i class="fas fa-flag-checkered"></i>' : 
        'التالي <i class="fas fa-arrow-left"></i>';
}

function startTimer(totalSeconds) {
    timeLeft = totalSeconds;
    updateTimerDisplay();
    
    if (timer) clearInterval(timer);
    
    timer = setInterval(() => {
        timeLeft--;
        updateTimerDisplay();
        
        if (timeLeft <= 0) {
            clearInterval(timer);
            finishQuiz();
        }
    }, 1000);
}

function updateTimerDisplay() {
    const minutes = Math.floor(timeLeft / 60);
    const seconds = timeLeft % 60;
    const timerDisplay = document.getElementById('quiz-timer');
    
    timerDisplay.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    
    if (timeLeft <= 60) {
        timerDisplay.className = 'timer-display timer-danger';
    } else if (timeLeft <= 180) {
        timerDisplay.className = 'timer-display timer-warning';
    } else {
        timerDisplay.className = 'timer-display';
    }
}

function updateQuizStats() {
    document.getElementById('current-score').textContent = userScore;
    
    const correctCount = userAnswers.reduce((count, answer, index) => {
        if (answer !== undefined && answer === currentQuizQuestions[index].correct) {
            return count + 1;
        }
        return count;
    }, 0);
    
    document.getElementById('correct-answers').textContent = correctCount;
}

function finishQuiz() {
    if (timer) clearInterval(timer);
    
    const quizContainer = document.getElementById('quiz-container');
    const totalQuestions = currentQuizQuestions.length;
    const answeredQuestions = userAnswers.filter(a => a !== undefined).length;
    const correctAnswers = userAnswers.reduce((count, answer, index) => {
        if (answer !== undefined && answer === currentQuizQuestions[index].correct) {
            return count + 1;
        }
        return count;
    }, 0);
    
    const percentage = Math.round((correctAnswers / totalQuestions) * 100);
    let badge = '🥉';
    let badgeColor = '#cd7f32';
    
    if (percentage >= 80) {
        badge = '🥇';
        badgeColor = '#FFD700';
    } else if (percentage >= 60) {
        badge = '🥈';
        badgeColor = '#C0C0C0';
    }
    
    quizContainer.innerHTML = `
        <div class="quiz-results">
            <div class="quiz-badge" style="background: linear-gradient(135deg, ${badgeColor}, ${badgeColor}dd)">
                ${badge}
            </div>
            <h2>نتيجة الاختبار</h2>
            <div class="quiz-score">${userScore} نقطة</div>
            <div style="margin-bottom: 2rem;">
                <p>لقد أجبت على ${answeredQuestions} من ${totalQuestions} سؤال</p>
                <p>الإجابات الصحيحة: ${correctAnswers}</p>
                <p>النسبة المئوية: ${percentage}%</p>
            </div>
            <div class="payment-actions">
                <button class="btn" id="review-quiz">
                    <i class="fas fa-redo"></i> مراجعة الإجابات
                </button>
                <button class="btn" id="new-quiz">
                    <i class="fas fa-plus"></i> اختبار جديد
                </button>
            </div>
        </div>
    `;
    
    document.getElementById('review-quiz').addEventListener('click', () => {
        currentQuestionIndex = 0;
        showQuestion(currentQuestionIndex);
    });
    
    document.getElementById('new-quiz').addEventListener('click', () => {
        quizContainer.classList.remove('active');
        initializeQuizSystem();
    });
    
    saveToLeaderboard(userScore, percentage);
    
    showNotification(`تهانينا! لقد حصلت على ${userScore} نقطة في الاختبار`, 'success');
}

function saveToLeaderboard(score, percentage) {
    let leaderboard = JSON.parse(localStorage.getItem('quizLeaderboard') || '[]');
    
    const username = localStorage.getItem('username') || `مستخدم ${Math.floor(Math.random() * 1000)}`;
    const newEntry = {
        username: username,
        score: score,
        percentage: percentage,
        date: new Date().toLocaleDateString('ar-EG'),
        level: currentQuiz
    };
    
    leaderboard.push(newEntry);
    
    leaderboard.sort((a, b) => b.score - a.score);
    
    leaderboard = leaderboard.slice(0, 10);
    
    localStorage.setItem('quizLeaderboard', JSON.stringify(leaderboard));
    
    updateLeaderboard();
}

function updateLeaderboard() {
    const leaderboardBody = document.getElementById('leaderboard-body');
    const leaderboard = JSON.parse(localStorage.getItem('quizLeaderboard') || '[]');
    
    leaderboardBody.innerHTML = '';
    
    if (leaderboard.length === 0) {
        leaderboardBody.innerHTML = `
            <div style="text-align: center; padding: 2rem; color: var(--secondary-color);">
                <i class="fas fa-trophy" style="font-size: 2rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                <p>لا توجد نتائج بعد. كن أول المتصدرين!</p>
            </div>
        `;
        return;
    }
    
    leaderboard.forEach((entry, index) => {
        const row = document.createElement('div');
        row.className = 'leaderboard-row';
        
        let badgeCount = '';
        if (entry.percentage >= 80) {
            badgeCount = '<div class="badge" style="background: linear-gradient(135deg, #FFD700, #FFA500)">🥇</div>';
        } else if (entry.percentage >= 60) {
            badgeCount = '<div class="badge" style="background: linear-gradient(135deg, #C0C0C0, #A0A0A0)">🥈</div>';
        } else {
            badgeCount = '<div class="badge" style="background: linear-gradient(135deg, #cd7f32, #a0522d)">🥉</div>';
        }
        
        row.innerHTML = `
            <div class="leaderboard-rank">#${index + 1}</div>
            <div class="leaderboard-user">
                <div class="leaderboard-avatar">${entry.username.charAt(0)}</div>
                <div>
                    <div>${entry.username}</div>
                    <div style="font-size: 0.8rem; color: var(--secondary-color);">${entry.date}</div>
                </div>
            </div>
            <div class="leaderboard-score">${entry.score}</div>
            <div class="leaderboard-badges">${badgeCount}</div>
        `;
        
        leaderboardBody.appendChild(row);
    });
}

// ==================== المساعد الذكي المتقدم ====================
function initializeAIAssistant() {
    const aiToggle = document.getElementById('ai-toggle');
    const aiChat = document.getElementById('ai-chat');
    const aiMessages = document.getElementById('ai-messages');
    const aiInput = document.getElementById('ai-input');
    const aiSend = document.getElementById('ai-send');
    const aiNewChat = document.getElementById('ai-new-chat');
    const aiClearChat = document.getElementById('ai-clear-chat');
    const aiCloseChat = document.getElementById('ai-close-chat');
    const aiSuggestions = document.getElementById('ai-suggestions');
    const aiFeatures = document.querySelectorAll('.ai-feature');
    
    function getCurrentTime() {
        const now = new Date();
        return formatTime12Hour(now, currentTimezone);
    }
    
    document.getElementById('welcome-time').textContent = getCurrentTime();
    
    const aiResponses = {
        "السلام عليكم": ["وعليكم السلام ورحمة الله وبركاته! أهلاً وسهلاً بيك. كيف يمكنني مساعدتك اليوم؟"],
        "مرحبا": ["مرحباً بيك! 🌟 إزاي أقدر أساعدك النهاردة؟"],
        "شكرا": ["العفو! دا واجبي. 😊"],
        "اسعار": ["أسعار التذاكر بتختلف من معلم لمعلم. الأهرامات بتبدأ من 440 جنيه للأجانب و40 جنيه للمصريين."],
        "حجز": ["عشان تحجز رحلة، روح لقسم الحجز في الصفحة واختار المعلم اللي عايز تزوره وتاريخ الزيارة وعدد الأشخاص."],
        "رصيد": ["رصيدك الحالي في المحفظة يمكنك التحقق منه من قسم المحفظة في التطبيق."],
        "ترجمة": ["أقدر أساعدك في الترجمة بين العربية والإنجليزية. اكتب الجملة اللي عايز تترجمها."],
        "معلومات تاريخية": ["أقدر أقدم لك معلومات تاريخية مفصلة عن أي فترة من فترات التاريخ المصري."]
    };
    
    aiToggle.addEventListener('click', () => {
        aiChat.classList.toggle('active');
    });
    
    aiCloseChat.addEventListener('click', () => {
        aiChat.classList.remove('active');
    });
    
    function sendMessage() {
        const message = aiInput.value.trim();
        if (message === '') return;
        
        addMessage(message, 'user');
        aiInput.value = '';
        aiSend.disabled = true;
        
        const typingIndicator = document.createElement('div');
        typingIndicator.className = 'typing-indicator';
        typingIndicator.innerHTML = `
            <div class="typing-dot"></div>
            <div class="typing-dot"></div>
            <div class="typing-dot"></div>
        `;
        aiMessages.appendChild(typingIndicator);
        aiMessages.scrollTop = aiMessages.scrollHeight;
        
        setTimeout(() => {
            aiMessages.removeChild(typingIndicator);
            
            let response = generateAIResponse(message);
            addMessage(response, 'ai');
            aiSend.disabled = false;
        }, 1500 + Math.random() * 1000);
    }
    
    function generateAIResponse(message) {
        for (const [key, values] of Object.entries(aiResponses)) {
            if (message.toLowerCase().includes(key.toLowerCase())) {
                return values[Math.floor(Math.random() * values.length)];
            }
        }
        
        const generalResponses = [
            "هذا سؤال مثير للاهتمام! يمكنني مساعدتك في ذلك.",
            "أفهم استفسارك. دعني أفكر في أفضل طريقة للإجابة...",
            "هذا موضوع رائع! بناءً على معرفتي، يمكنني تقديم المعلومات التالية:"
        ];
        
        return generalResponses[Math.floor(Math.random() * generalResponses.length)];
    }
    
    function addMessage(text, sender) {
        const messageElement = document.createElement('div');
        messageElement.className = `message ${sender}-message`;
        
        const timeElement = document.createElement('div');
        timeElement.className = 'message-time';
        timeElement.textContent = getCurrentTime();
        
        messageElement.textContent = text;
        messageElement.appendChild(timeElement);
        
        aiMessages.appendChild(messageElement);
        aiMessages.scrollTop = aiMessages.scrollHeight;
    }
    
    aiSend.addEventListener('click', sendMessage);
    
    aiInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            sendMessage();
        }
    });
    
    aiSuggestions.querySelectorAll('.ai-suggestion').forEach(suggestion => {
        suggestion.addEventListener('click', function() {
            const suggestionText = this.getAttribute('data-suggestion');
            aiInput.value = suggestionText;
            sendMessage();
        });
    });
    
    aiFeatures.forEach(feature => {
        feature.addEventListener('click', function() {
            const featureType = this.getAttribute('data-feature');
            let message = "";
            
            switch(featureType) {
                case 'plan_trip':
                    message = "أريد مساعدتك في تخطيط رحلة سياحية. أخبرني بالمدة والميزانية والاهتمامات.";
                    break;
                case 'history_info':
                    message = "أريد معرفة معلومات تاريخية عن مصر القديمة. ما هي الفترة التي تريد معرفة المزيد عنها؟";
                    break;
                case 'wallet_help':
                    message = "أحتاج مساعدة في إدارة محفظتي الإلكترونية. ما هي الخدمة التي تريدها؟";
                    break;
                case 'translate':
                    message = "أريد ترجمة نص من العربية إلى الإنجليزية أو العكس. ما هو النص الذي تريد ترجمته؟";
                    break;
            }
            
            aiInput.value = message;
            sendMessage();
        });
    });
}

// ==================== إنشاء الجسيمات المتحركة ====================
function createParticles() {
    const container = document.getElementById('particle-container');
    for (let i = 0; i < 50; i++) {
        const particle = document.createElement('div');
        particle.className = 'particle';
        particle.style.left = `${Math.random() * 100}%`;
        particle.style.animationDelay = `${Math.random() * 20}s`;
        particle.style.animationDuration = `${15 + Math.random() * 10}s`;
        container.appendChild(particle);
    }
}

// ==================== تهيئة النظام ====================
document.addEventListener('DOMContentLoaded', function() {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
        document.body.classList.add('dark-mode');
        document.getElementById('theme-toggle').innerHTML = '<i class="fas fa-sun"></i>';
    }
    
    document.getElementById('theme-toggle').addEventListener('click', toggleDarkMode);
    
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const section = this.getAttribute('data-section');
            switchSection(section);
        });
    });
    
    document.getElementById('timezone-select').addEventListener('change', function() {
        changeTimezone(this.value);
    });
    
    document.querySelectorAll('.close-modal').forEach(button => {
        button.addEventListener('click', function() {
            this.closest('.modal').classList.remove('active');
        });
    });
    
    document.querySelectorAll('.modal').forEach(modal => {
        modal.addEventListener('click', function(e) {
            if (e.target === this) {
                this.classList.remove('active');
            }
        });
    });
    
    displaySites();
    displayKings();
    initializeSearchSystem();
    initializeBookingSystem();
    const walletManager = initializeWalletMain();
    initializeQuizSystem();
    updateLeaderboard();
    initializeAIAssistant();
    
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('date').value = today;
    document.getElementById('date').min = today;
    
    const systemLanguage = detectSystemLanguage();
    const welcomeMessage = systemLanguage === 'ar' ? 
        'مرحباً بك في تطبيق أبو الهول للرحلات الأثرية!' : 
        'Welcome to the Sphinx Archaeological Tours App!';
    
    showNotification(welcomeMessage, 'success');
});

createParticles();