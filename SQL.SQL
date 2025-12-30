-- إنشاء قاعدة البيانات
CREATE DATABASE IF NOT EXISTS sphinx_tours;
USE sphinx_tours;

-- جدول المستخدمين
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    national_id VARCHAR(14) UNIQUE,
    user_type ENUM('admin', 'tourist', 'guide') DEFAULT 'tourist',
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    profile_image VARCHAR(255),
    language_preference ENUM('ar', 'en') DEFAULT 'ar',
    theme_preference ENUM('light', 'dark') DEFAULT 'light',
    wallet_balance DECIMAL(10, 2) DEFAULT 0.00
);

-- جدول المعالم الأثرية
CREATE TABLE archaeological_sites (
    site_id INT PRIMARY KEY AUTO_INCREMENT,
    name_ar VARCHAR(150) NOT NULL,
    name_en VARCHAR(150),
    location_ar VARCHAR(200) NOT NULL,
    location_en VARCHAR(200),
    era_ar VARCHAR(100) NOT NULL,
    era_en VARCHAR(100),
    description_ar TEXT,
    description_en TEXT,
    foreign_price DECIMAL(10, 2) NOT NULL,
    egyptian_price DECIMAL(10, 2) NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    egyptian_base_price DECIMAL(10, 2) NOT NULL,
    visiting_hours_ar VARCHAR(200),
    visiting_hours_en VARCHAR(200),
    image_url VARCHAR(500),
    popularity_score INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_site_name (name_ar),
    INDEX idx_location (location_ar)
);

-- جدول ملوك مصر
CREATE TABLE egyptian_kings (
    king_id INT PRIMARY KEY AUTO_INCREMENT,
    name_ar VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    era_ar VARCHAR(100) NOT NULL,
    era_en VARCHAR(100),
    reign_period VARCHAR(50),
    description_ar TEXT,
    description_en TEXT,
    burial_site VARCHAR(100),
    image_url VARCHAR(500),
    achievements JSON,
    importance_rating INT DEFAULT 5,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_king_name (name_ar),
    INDEX idx_era (era_ar)
);

-- جدول الحجوزات
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_number VARCHAR(20) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    site_id INT NOT NULL,
    booking_date DATE NOT NULL,
    visit_date DATE NOT NULL,
    number_of_visitors INT NOT NULL,
    visitor_type ENUM('egyptian', 'foreign') NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    booking_status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    payment_method VARCHAR(50),
    payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    payment_date TIMESTAMP NULL,
    special_requests TEXT,
    guide_requested BOOLEAN DEFAULT FALSE,
    transport_requested BOOLEAN DEFAULT FALSE,
    lunch_requested BOOLEAN DEFAULT FALSE,
    photo_service_requested BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (site_id) REFERENCES archaeological_sites(site_id) ON DELETE CASCADE,
    INDEX idx_booking_number (booking_number),
    INDEX idx_user_bookings (user_id, booking_date),
    INDEX idx_visit_date (visit_date)
);

-- جدول معاملات المحفظة
CREATE TABLE wallet_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    transaction_type ENUM('deposit', 'withdrawal', 'booking_payment', 'refund', 'bonus') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    description VARCHAR(255),
    reference_id VARCHAR(50), -- ID للحجز أو عملية خارجية
    transaction_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    payment_gateway VARCHAR(50),
    gateway_transaction_id VARCHAR(100),
    balance_before DECIMAL(10, 2),
    balance_after DECIMAL(10, 2),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_transactions (user_id, transaction_date),
    INDEX idx_transaction_type (transaction_type)
);

-- جدول كلمات مرور المحفظة
CREATE TABLE wallet_security (
    security_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    security_question VARCHAR(255),
    security_answer_hash VARCHAR(255),
    password_set_date TIMESTAMP,
    last_password_change TIMESTAMP,
    password_attempts INT DEFAULT 0,
    account_locked_until TIMESTAMP NULL,
    two_factor_enabled BOOLEAN DEFAULT FALSE,
    two_factor_secret VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- جدول أسئلة الاختبار
CREATE TABLE quiz_questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    question_text_ar TEXT NOT NULL,
    question_text_en TEXT,
    option_a_ar VARCHAR(255) NOT NULL,
    option_b_ar VARCHAR(255) NOT NULL,
    option_c_ar VARCHAR(255),
    option_d_ar VARCHAR(255),
    option_a_en VARCHAR(255),
    option_b_en VARCHAR(255),
    option_c_en VARCHAR(255),
    option_d_en VARCHAR(255),
    correct_option INT NOT NULL, -- 1, 2, 3, 4
    explanation_ar TEXT,
    explanation_en TEXT,
    difficulty_level ENUM('easy', 'medium', 'hard') DEFAULT 'easy',
    category VARCHAR(50),
    points INT DEFAULT 10,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_difficulty (difficulty_level),
    INDEX idx_category (category)
);

-- جدول نتائج الاختبارات
CREATE TABLE quiz_results (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    quiz_level INT NOT NULL, -- 1, 2, 3
    total_questions INT NOT NULL,
    correct_answers INT NOT NULL,
    score INT NOT NULL,
    percentage DECIMAL(5, 2) NOT NULL,
    time_taken_seconds INT,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_results (user_id, completed_at),
    INDEX idx_quiz_level (quiz_level)
);

-- جدول المتصدرين
CREATE TABLE leaderboard (
    leaderboard_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    username VARCHAR(50) NOT NULL,
    total_score INT DEFAULT 0,
    quizzes_taken INT DEFAULT 0,
    average_percentage DECIMAL(5, 2) DEFAULT 0.00,
    last_quiz_date TIMESTAMP,
    rank_position INT,
    badge_level ENUM('bronze', 'silver', 'gold', 'platinum') DEFAULT 'bronze',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_leaderboard_rank (rank_position),
    INDEX idx_total_score (total_score DESC)
);

-- جدول الإنجازات
CREATE TABLE achievements (
    achievement_id INT PRIMARY KEY AUTO_INCREMENT,
    name_ar VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    description_ar TEXT,
    description_en TEXT,
    icon_class VARCHAR(50),
    requirement_type ENUM('score', 'quizzes', 'bookings', 'streak') NOT NULL,
    requirement_value INT NOT NULL,
    reward_points INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول إنجازات المستخدمين
CREATE TABLE user_achievements (
    user_achievement_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    achievement_id INT NOT NULL,
    progress_current INT DEFAULT 0,
    progress_required INT NOT NULL,
    is_unlocked BOOLEAN DEFAULT FALSE,
    unlocked_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(achievement_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_achievement (user_id, achievement_id)
);

-- جدول محادثات المساعد الذكي
CREATE TABLE ai_chat_sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    session_token VARCHAR(100) UNIQUE NOT NULL,
    context_data JSON, -- بيانات سياقية للمحادثة
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_sessions (user_id, created_at)
);

-- جدول رسائل المساعد الذكي
CREATE TABLE ai_chat_messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    session_id INT NOT NULL,
    message_type ENUM('user', 'ai') NOT NULL,
    message_content TEXT NOT NULL,
    message_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ai_response_type VARCHAR(50), -- نوع الرد (معلومات تاريخية، تخطيط رحلة، إلخ)
    metadata JSON,
    FOREIGN KEY (session_id) REFERENCES ai_chat_sessions(session_id) ON DELETE CASCADE,
    INDEX idx_session_messages (session_id, message_timestamp)
);

-- جدول سجلات البحث
CREATE TABLE search_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    search_query TEXT NOT NULL,
    search_results_count INT DEFAULT 0,
    search_category VARCHAR(50),
    search_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_ip VARCHAR(45),
    user_agent TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_search_queries (search_query(100)),
    INDEX idx_search_time (search_timestamp)
);

-- جدول الإشعارات
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    notification_type ENUM('booking', 'wallet', 'quiz', 'system', 'promotion') NOT NULL,
    title_ar VARCHAR(200) NOT NULL,
    title_en VARCHAR(200),
    message_ar TEXT NOT NULL,
    message_en TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    is_important BOOLEAN DEFAULT FALSE,
    action_url VARCHAR(500),
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_notifications (user_id, is_read, sent_at)
);

-- جدول المراجعات والتقييمات
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    site_id INT,
    booking_id INT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    helpful_count INT DEFAULT 0,
    is_verified BOOLEAN DEFAULT FALSE, -- إذا كانت من حجز فعلي
    is_approved BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (site_id) REFERENCES archaeological_sites(site_id) ON DELETE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE SET NULL,
    UNIQUE KEY unique_booking_review (booking_id),
    INDEX idx_site_reviews (site_id, created_at DESC)
);

-- جدول المحتوى التعليمي
CREATE TABLE educational_content (
    content_id INT PRIMARY KEY AUTO_INCREMENT,
    title_ar VARCHAR(200) NOT NULL,
    title_en VARCHAR(200),
    content_type ENUM('article', 'video', 'image_gallery', 'interactive') NOT NULL,
    content_ar TEXT,
    content_en TEXT,
    thumbnail_url VARCHAR(500),
    video_url VARCHAR(500),
    related_site_id INT,
    related_king_id INT,
    difficulty_level ENUM('beginner', 'intermediate', 'advanced') DEFAULT 'beginner',
    views_count INT DEFAULT 0,
    likes_count INT DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE,
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (related_site_id) REFERENCES archaeological_sites(site_id) ON DELETE SET NULL,
    FOREIGN KEY (related_king_id) REFERENCES egyptian_kings(king_id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_content_type (content_type),
    INDEX idx_published (published_at DESC)
);

-- جدول الجولات الافتراضية
CREATE TABLE virtual_tours (
    tour_id INT PRIMARY KEY AUTO_INCREMENT,
    site_id INT NOT NULL,
    tour_name_ar VARCHAR(150) NOT NULL,
    tour_name_en VARCHAR(150),
    tour_description_ar TEXT,
    tour_description_en TEXT,
    panorama_url TEXT,
    hotspot_data JSON,
    duration_minutes INT DEFAULT 10,
    is_free BOOLEAN DEFAULT TRUE,
    price DECIMAL(10, 2) DEFAULT 0.00,
    views_count INT DEFAULT 0,
    average_rating DECIMAL(3, 2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (site_id) REFERENCES archaeological_sites(site_id) ON DELETE CASCADE,
    INDEX idx_tour_site (site_id)
);

-- جدول العملات الافتراضية
CREATE TABLE virtual_currency (
    currency_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    gold_coins INT DEFAULT 0,
    silver_coins INT DEFAULT 0,
    experience_points INT DEFAULT 0,
    level INT DEFAULT 1,
    daily_streak INT DEFAULT 0,
    last_daily_reward TIMESTAMP NULL,
    total_earned_coins INT DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_currency (user_id)
);

-- جدول العروض والخصومات
CREATE TABLE offers_discounts (
    offer_id INT PRIMARY KEY AUTO_INCREMENT,
    offer_code VARCHAR(50) UNIQUE NOT NULL,
    offer_name_ar VARCHAR(150) NOT NULL,
    offer_name_en VARCHAR(150),
    offer_type ENUM('percentage', 'fixed', 'free_service') NOT NULL,
    discount_value DECIMAL(10, 2),
    min_booking_amount DECIMAL(10, 2),
    max_discount DECIMAL(10, 2),
    valid_from DATE NOT NULL,
    valid_until DATE NOT NULL,
    usage_limit INT DEFAULT 1,
    times_used INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    applicable_sites JSON, -- مواقع محددة أو جميعها
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_offer_code (offer_code),
    INDEX idx_valid_dates (valid_from, valid_until)
);

-- جدول استخدام العروض
CREATE TABLE offer_usage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    offer_id INT NOT NULL,
    user_id INT NOT NULL,
    booking_id INT,
    discount_applied DECIMAL(10, 2) NOT NULL,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (offer_id) REFERENCES offers_discounts(offer_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE SET NULL,
    INDEX idx_user_offers (user_id, used_at)
);

-- جدول إحصائيات الموقع
CREATE TABLE site_statistics (
    stat_id INT PRIMARY KEY AUTO_INCREMENT,
    stat_date DATE NOT NULL,
    total_users INT DEFAULT 0,
    new_users INT DEFAULT 0,
    total_bookings INT DEFAULT 0,
    completed_bookings INT DEFAULT 0,
    total_revenue DECIMAL(15, 2) DEFAULT 0.00,
    total_quiz_attempts INT DEFAULT 0,
    average_quiz_score DECIMAL(5, 2) DEFAULT 0.00,
    most_popular_site_id INT,
    most_active_user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_stat_date (stat_date),
    INDEX idx_stat_date (stat_date),
    FOREIGN KEY (most_popular_site_id) REFERENCES archaeological_sites(site_id) ON DELETE SET NULL,
    FOREIGN KEY (most_active_user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- جدول السجل الأمني
CREATE TABLE security_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action_type VARCHAR(100) NOT NULL,
    description TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    status ENUM('success', 'failure', 'warning') NOT NULL,
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_security_logs (user_id, log_timestamp),
    INDEX idx_action_type (action_type)
);

-- جدول النسخ الاحتياطي
CREATE TABLE backup_history (
    backup_id INT PRIMARY KEY AUTO_INCREMENT,
    backup_type VARCHAR(50) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size BIGINT,
    backup_status ENUM('success', 'failed', 'in_progress') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    notes TEXT,
    INDEX idx_backup_date (created_at)
);
-- إدخال بيانات المعالم الأثرية
INSERT INTO archaeological_sites (name_ar, location_ar, era_ar, description_ar, foreign_price, egyptian_price, base_price, egyptian_base_price, visiting_hours_ar, image_url) VALUES
('المتحف المصري الكبير (GEM)', 'منطقة الأهرامات، الجيزة', 'العصر الحديث (متحف)', 'أحد أكبر وأهم المتاحف الأثرية في العالم. يقع على بعد أمتار من الأهرامات ويعرض أكثر من 50,000 قطعة أثرية، أهمها المجموعة الكاملة لمقبرة توت عنخ آمون.', 500, 100, 500, 100, 'مفتوح الآن (يوصى بالحجز المسبق عبر موقعه الرسمي). مواعيد العمل: 9 ص - 5 م (قد تتغير).', 'https://earthsguards.com/wp-content/uploads/2025/06/musume2.jpg'),
('أهرامات الجيزة', 'الجيزة', 'الدولة القديمة (أسرة 4)', 'أشهر معالم مصر، وتضم ثلاثة أهرامات: خوفو (الأكبر)، خفرع، ومنقرع. بُنيت كمقابر ملكية وتعتبر إحدى عجائب الدنيا السبع القديمة والوحيدة التي لا تزال قائمة.', 440, 40, 440, 40, 'يوميًا: 8 ص - 5 م (شتاءً)، 7 ص - 7 م (صيفاً)', 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/06/7e/7d/2c/pyramids-of-giza.jpg?w=1200&h=1200&s=1'),
('أبو الهول', 'الجيزة', 'الدولة القديمة (أسرة 4)', 'تمثال أسطوري بجسم أسد ورأس إنسان، يُعتقد أنه يمثل الملك خفرع. يحرس هضبة الجيزة وهو منحوت من كتلة صخرية واحدة.', 0, 0, 0, 0, 'نفس أوقات منطقة الأهرامات', 'https://www.independentarabia.com/sites/default/files/styles/1368x911/public/article/mainimage/2022/05/27/549211-1616005704.jpg'),
('معبد الكرنك', 'الأقصر', 'الدولة الحديثة', 'أكبر مجمع ديني قديم في العالم. كان مخصصًا لعبادة الثالوث الثيبي (آمون، موت، خونسو). يشتهر بصروحه الضخمة وقاعة الأعمدة الكبرى التي تضم 134 عمودًا.', 300, 40, 300, 40, 'يوميًا: 6 ص - 5:30 م (شتاءً)، 6 ص - 6 م (صيفًا)', 'https://explore.rehlat.ae/static/media/searchdestination/thingstodo/images/luxor/temple_of_karnak/large_Templo_de_Karnak,_Luxor,_Egipto,.webp'),
('معبد الأقصر', 'الأقصر', 'الدولة الحديثة (الأسرة 18)', 'بني principalmente الملكان أمنحتب الثالث ورمسيس الثاني لاحتفالات عيد الأوبت. يتصل بمعبد الكرنك عبر طريق الكباش.', 260, 30, 260, 30, 'يوميًا: 6 ص - 10 م', 'https://hurghadalovers.com/wp-content/uploads/2023/02/Luxor-Temple-Egyptian-Temples-Statue-of-King-Ramesses-II-Avenue-of-Sphinxes_0076-1140x530.jpg'),
('وادي الملوك', 'الضفة الغربية, الأقصر', 'الدولة الحديثة', 'مقبرة ملوك الدولة الحديثة، حيث كان يتم دفن الفراعنة في مقابر منحوتة في الصخر بعيدًا عن اللصوص. أشهرها مقبرة توت عنخ آمون.', 400, 40, 400, 40, 'يوميًا: 6 ص - 5 م (شتاءً)، 6 ص - 6 م (صيفًا)', 'https://tripawayjo.com/wp-content/uploads/2023/11/11-66.jpg.webp'),
('معبد حتشبسوت', 'الدير البحري, الأقصر', 'الدولة الحديثة (الأسرة 18)', 'معبد جنائزي للملكة حتشبسوت، أحد أروع المعابد في مصر. يتميز بتصميمه الفريد المكون من ثلاثة طوابق متدرجة.', 240, 30, 240, 30, 'يوميًا: 6 ص - 5 م', 'https://www.abou-alhool.com/ima/43465_IMG-20200130-WA0224.jpg'),
('معبد أبو سمبل', 'أسوان', 'الدولة الحديثة (رمسيس الثاني)', 'معبدان منحوتان في الصخر، بناهما رمسيس الثاني. تم نقلهما في الستينيات لإنقاذهما من الغرق بسبب بناء السد العالي.', 415, 50, 415, 50, 'يوميًا: 6 ص - 5 م', 'https://mota.gov.eg/media/14dgp2m4/ab-samble.jpg?width=1240&height=524&rnd=133038464288800000'),
('معبد فيلة', 'أسوان', 'العصر البطلمي والروماني', 'معبد مخصص للإلهة إيزيس، تم نقله من جزيرة فيلة إلى جزيرة أجيليكا لإنقاذه من الغرق. يعتبر من أجمل المعابد في مصر.', 300, 40, 300, 40, 'يوميًا: 7 ص - 4 م', 'https://api.soundandlight.show/photos/philae-show/philae-2.webp'),
('معبد إدفو', 'إدفو', 'العصر البطلمي', 'معبد مخصص للإله حورس، وهو من أفضل المعابد المحفوظة في مصر. يعد ثاني أكبر معبد بعد معبد الكرنك.', 300, 40, 300, 40, 'يوميًا: 7 ص - 4 م', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/The_Temple_of_Edfu_%D9%85%D8%B9%D8%A8%D8%AF_%D8%A7%D8%AF%D9%81%D9%88.jpg/330px-The_Temple_of_Edfu_%D9%85%D8%B9%D8%A8%D8%AF_%D8%A7%D8%AF%D9%81%D9%88.jpg'),
('معبد كوم أمبو', 'كوم أمبو', 'العصر البطلمي', 'معبد مزدوج مخصص للإلهين حورس وسوبek. يتميز بتصميمه الفريد حيث ينقسم إلى قسمين متماثلين.', 240, 30, 240, 30, 'يوميًا: 7 ص - 5 م', 'https://mota.gov.eg/media/skudako0/kom-ombo.jpg?width=1240&height=524&rnd=133037827956070000'),
('هرم سقارة المدرج', 'سقارة', 'الدولة القديمة (الأسرة 3)', 'أقدم هرم في مصر، بني للملك زوسر. صممه المهندس إمحوتب ويعتبر أول بناء حجري ضخم في التاريخ.', 180, 30, 180, 30, 'يوميًا: 8 ص - 5 م', 'https://cdn1-m.alittihad.ae/store/archive/image/2024/10/12/a82af69a-2c31-411d-9e66-c5bfc981e9bf.png'),
('هرم ميدوم', 'ميدوم', 'الدولة القديمة (الأسرة 4)', 'أحد أقدم الأهرامات في مصر، بني للملك حوني وأكمله سنفرو. يتميز بشكله الغريب الذي يشبه البرج.', 100, 20, 100, 20, 'يوميًا: 8 ص - 5 م', 'https://upload.wikimedia.org/wikipedia/commons/3/37/%D9%87%D8%B1%D9%85_%D9%85%D9%8A%D8%AF%D9%88%D9%85.jpg'),
('دهشور', 'دهشور', 'الدولة القديمة (الأسرة 4)', 'موقع يضم هرمين للملك سنفرو: الهرم المنحني والهرم الأحمر. يعتبر الهرم الأحمر أول هرم حقيقي في مصر.', 120, 20, 120, 20, 'يوميًا: 8 ص - 5 م', 'https://mota.gov.eg/media/zqce1zj3/%D8%AF%D9%87%D8%B4%D9%88%D8%B1-2.jpg?width=1055&height=593&rnd=133019010084830000'),
('أبيدوس', 'أبيدوس', 'الدولة القديمة والحديثة', 'من أهم المواقع الدينية في مصر القديمة، حيث كان مركز عبادة الإله أوزيريس. يضم معابد لستي الأول ورمسيس الثاني.', 200, 30, 200, 30, 'يوميًا: 7 ص - 5 م', 'https://upload.wikimedia.org/wikipedia/commons/3/33/AbydosFacade.jpg'),
('دندرة', 'دندرة', 'العصر البطلمي والروماني', 'مجمع معابد مخصص للإلهة حتحور. يشتهر بمنظره الفلكي المحفوظ جيداً على سقف المعبد.', 180, 30, 180, 30, 'يوميًا: 7 ص - 5 م', 'https://egymonuments.gov.eg//media/3108/Untitled1.jpg?center=0.50810810810810814,0.5&mode=crop&width=1200&height=630&rnd=133764904560000000'),
('معبد الرامسيوم', 'الأقصر', 'الدولة الحديثة (رمسيس الثاني)', 'معبد جنائزي لرمسيس الثاني، يضم تماثيل ضخمة للملك وآثاراً من معاركه الشهيرة.', 120, 20, 120, 20, 'يوميًا: 6 ص - 5 م', 'https://egymonuments.gov.eg/media/8507/whatsapp-image-2024-11-19-at-114258-am.jpeg'),
('معبد سيتي الأول', 'أبيدوس', 'الدولة الحديثة (الأسرة 19)', 'معبد مخصص للإله أوزيريس، يشتهر بقائمة الملوك التي تسجل أسماء الفراعنة من مينا إلى سيتي الأول.', 150, 25, 150, 25, 'يوميًا: 7 ص - 5 م', 'https://thebrainchamber.com/wp-content/uploads/2023/12/Temple-of-Seti-I-in-Abydos-3.jpg'),
('معبد حورس', 'إدفو', 'العصر البطلمي', 'أكبر معبد مخصص للإله حورس، وهو من أفضل المعابد المحفوظة في مصر. بني بين 237 و57 ق.م.', 180, 30, 180, 30, 'يوميًا: 7 ص - 4 م', 'https://media.elwatannews.com/media/img/mediaarc/large/9979255141664096349.jpg'),
('معابد الفنتين', 'أسوان', 'الدولة القديمة والحديثة', 'مجموعة من المعابد على جزيرة الفنتين، تشمل معابد خنوم وساتت وآخرى. كانت مركزاً مهماً في العصور القديمة.', 120, 20, 120, 20, 'يوميًا: 7 ص - 4 م', 'https://mota.gov.eg/media/y0cl1glw/%D8%A7%D9%84%D9%81%D9%86%D8%AA%D9%8A%D9%8A%D9%86-1.jpg?width=1240&height=524&rnd=133029140608270000');

-- إدخال بيانات ملوك مصر
INSERT INTO egyptian_kings (name_ar, era_ar, reign_period, description_ar, burial_site, image_url, achievements) VALUES
('نارمر (مينا)', 'العصر العتيق (الأسرة الأولى)', 'حوالي 3100 ق.م', 'يعتبر أول ملك لمصر الموحدة ومؤسس الأسرة الأولى. قام بتوحيد مصر العليا والسفلى وأسس مدينة منف.', 'أبيدوس', 'https://admin.almalnews.com/storage/uploads/2015/03/4af4354d-adb6-4ad2-bd4b-3776de74c3cc.jpg', '["توحيد مصر العليا والسفلى", "تأسيس الأسرة الأولى", "تأسيس مدينة منف"]'),
('خوفو', 'الدولة القديمة (الأسرة الرابعة)', '2589–2566 ق.م', 'ثاني فراعنة الأسرة الرابعة، اشتهر ببناء الهرم الأكبر في الجيزة، أحد عجائب الدنيا السبع.', 'الهرم الأكبر بالجيزة', 'https://upload.wikimedia.org/wikipedia/commons/5/59/Khufu.JPG', '["بناء الهرم الأكبر في الجيزة", "تطوير نظام إداري مركزي", "تعزيز التجارة الخارجية"]'),
('خفرع', 'الدولة القديمة (الأسرة الرابعة)', '2558–2532 ق.م', 'رابع فراعنة الأسرة الرابعة، ابن خوفو. بنى الهرم الثاني في الجيزة وأبو الهول العظيم.', 'الهرم الثاني بالجيزة', 'https://egymonuments.gov.eg//media/3725/1.jpg?center=0.5,0.5036496350364964&mode=crop&width=1200&height=630&rnd=132581519640000000', '["بناء الهرم الثاني بالجيزة", "تشييد تمثال أبو الهول", "تطوير الفن والعمارة المصرية"]'),
('منقرع', 'الدولة القديمة (الأسرة الرابعة)', '2532–2503 ق.م', 'خامس فراعنة الأسرة الرابعة، ابن خفرع. بنى الهرم الثالث والأصغر في مجمع أهرامات الجيزة.', 'الهرم الثالث بالجيزة', 'https://upload.wikimedia.org/wikipedia/commons/f/fb/Menkaura_Bust_Closeup.jpg', '["بناء الهرم الثالث بالجيزة", "تعزيز العلاقات التجارية", "تطوير النحت والفنون"]'),
('بيبي الثاني', 'الدولة القديمة (الأسرة السادسة)', '2278–2184 ق.م', 'خامس فراعنة الأسرة السادسة، اعتلى العصر وعمره 6 سنوات وحكم لمدة 94 عاماً، وهو أطول فترة حكم في التاريخ.', 'هرم في سقارة', 'https://www.annahar.com/Library/Images/Uploaded%20Images/2022/01/14/Mohamad/%D8%A7%D9%84%D9%85%D9%84%D9%83-%D8%A8%D9%8A%D8%A8%D9%8A-%D8%A7%D9%84%D8%AB%D8%A7%D9%86%D9%8A.jpg', '["أطول فترة حكم في التاريخ (94 عاماً)", "تنظيم بعثات تجارية", "بناء المعابد والمقابر"]'),
('منتوحتب الثاني', 'الدولة الوسطى (الأسرة الحادية عشر)', '2061–2010 ق.م', 'مؤسس الدولة الوسطى، أعاد توحيد مصر بعد فترة الاضمحلال الأولى وانتقل العاصمة إلى طيبة.', 'الدير البحري', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Mentuhotep_Seated.jpg/250px-Mentuhotep_Seated.jpg', '["إعادة توحيد مصر", "تأسيس الدولة الوسطى", "بناء المعابد في الدير البحري"]'),
('أمنمحات الأول', 'الدولة الوسطى (الأسرة الثانية عشر)', '1991–1962 ق.م', 'مؤسس الأسرة الثانية عشر، نقل العاصمة إلى إيثت تاوي وأعاد تنظيم الإدارة المركزية.', 'اللشت', 'https://img.youm7.com/ArticleImgs/2020/5/7/10243-%D8%A3%D9%85%D9%86%D9%85%D8%AD%D8%A7%D8%AA-%D8%A7%D9%84%D8%A3%D9%88%D9%84-(1).jfif', '["تأسيس الأسرة الثانية عشر", "نقل العاصمة إلى إيثت تاوي", "إصلاح النظام الإداري"]'),
('سنوسرت الثالث', 'الدولة الوسطى (الأسرة الثانية عشر)', '1878–1839 ق.م', 'أحد أعظم فراعنة الدولة الوسطى، وسع حدود مصر وقمع التمردات في النوبة وبنى القلاع العسكرية.', 'دهشور', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Statue_of_Amenemhat_III_standing.jpg/960px-Statue_of_Amenemhat_III_standing.jpg', '["توسعة حدود مصر", "قمع التمردات في النوبة", "بناء القلاع العسكرية", "تطوير نظام الري"]'),
('أحمس الأول', 'الدولة الحديثة (الأسرة الثامنة عشر)', '1550–1525 ق.م', 'محرر مصر ومؤسس الدولة الحديثة، طرد الهكسوس من مصر ووحد البلاد من جديد.', 'دراع أبو النجا', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjrobPEuIFxiDf_yW3X4jgK1eNW4iu69J6nOxAkKXofNZjXG7nsZ9GlbG6PZQlemmE97wo_WD1cOI7MrZZVDtAgWmvPwI3BGWwatjemcz99mXxiGeAnp_Vwz9AUzwQUGZVw0RtRyaXPdPo/s1600/%25D9%2585%25D8%25A7+%25D9%2587%25D9%2589+%25D8%25A7%25D9%2587%25D9%2585+%25D8%25A7%25D8%25B9%25D9%2585%25D8%25A7%25D9%2584+%25D8%25A7%25D9%2584%25D9%2585%25D9%2584%25D9%2583+%25D8%25A7%25D8%25AD%25D9%2585%25D8%25B3+%25D8%25A7%D9%2584%25D8%25A7%D9%2588%D9%2584+%25D9%2582%25D8%25A7%25D9%2587%D8%25B1+%25D8%25A7%D9%2584%D9%2587%D9%2583%D8%25B3%D9%2588%D8%25B3+%25D9%2588%D9%2585%D9%2586+%25D9%2587%25D9%2585+%25D8%25A7%25D9%2588%D9%2584%25D8%25A7%25D8%25AF%D9%2587+%25D8%25A7%D9%2584%D8%25B3%D8%25A8%25D8%25B9%25D8%25A9-5.jpg', '["طرد الهكسوس من مصر", "تأسيس الدولة الحديثة", "إعادة بناء المعابد"]'),
('حتشبسوت', 'الدولة الحديثة (الأسرة الثامنة عشر)', '1479–1458 ق.م', 'أشهر ملكات مصر، حكمت كفرعون واشتهرت برحلاتها التجارية إلى بلاد بونت وبناء معبدها في الدير البحري.', 'وادي الملوك', 'https://www.awanmasr.com/wp-content/uploads/2020/09/%D8%AD%D8%AA%D8%B4%D8%A8%D8%B3%D9%88%D8%AA.jpg', '["تنظيم رحلات تجارية إلى بلاد بونت", "بناء معبد الدير البحري", "تطوير التجارة والاقتصاد"]'),
('تحتمس الثالث', 'الدولة الحديثة (الأسرة الثامنة عشر)', '1479–1425 ق.م', 'يُلقب بنابليون مصر، وسع الإمبراطورية المصرية إلى أقصى حدودها وقاد 17 حملة عسكرية ناجحة.', 'وادي الملوك', 'https://upload.wikimedia.org/wikipedia/commons/5/57/Thutmosis_III-2.jpg', '["توسيع الإمبراطورية المصرية", "قيادة 17 حملة عسكرية", "بناء المسلات والمعابد"]'),
('أمنحتب الثالث', 'الدولة الحديثة (الأسرة الثامنة عشر)', '1388–1351 ق.م', 'عرف بعصر الازدهار والسلام، بنى العديد من المعابد والتماثيل الضخمة بما فيها ممنون.', 'وادي الملوك', 'https://upload.wikimedia.org/wikipedia/commons/b/bb/Colossal_Amenhotep_III_British_Museum.jpg', '["بناء معبد الأقصر", "تشييد تماثيل ممنون", "تطوير العلاقات الدبلوماسية"]'),
('أخناتون', 'الدولة الحديثة (الأسرة الثامنة عشر)', '1353–1336 ق.م', 'الملك المصلح الذي حاول توحيد الآلهة في إله واحد هو آتون ونقل العاصمة إلى أخيتاتون.', 'وادي الملوك', 'https://manshoor.com/uploads/2018/04/9a06e66509070cd057f3ec930819e434.jpg', '["الثورة الدينية (عبادة آتون)", "تأسيس العاصمة أخيتاتون", "تطوير الفن الواقعي"]'),
('توت عنخ آمون', 'الدولة الحديثة (الأسرة الثامنة عشر)', '1332–1323 ق.م', 'أشهر فراعنة مصر بسبب اكتشاف مقبرته سليمة عام 1922. عاد للديانة التقليدية بعد فترة أخناتون.', 'وادي الملوك', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/CairoEgMuseumTaaMaskMostlyPhotographed.jpg/330px-CairoEgMuseumTaaMaskMostlyPhotographed.jpg', '["العودة للديانة التقليدية", "إصلاح العلاقات مع الكهنة", "بناء المعابد"]'),
('رمسيس الثاني', 'الدولة الحديثة (الأسرة التاسعة عشر)', '1279–1213 ق.م', 'أعظم وأشهر فراعنة مصر، حكم لمدة 66 عاماً وبنى العديد من المعابد والتماثيل الضخمة.', 'وادي الملوك', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhHDffqGYostgOq_e-blVaQh6GVC3dePHDCHyT23UwFh-KDeypJ9adlArT8od8hTHfcjmzJLYpkD0iQxHvNSI2cz5xm-XXoIg2HBdtLOVBQeFOfwlbFZvhryUYXVeClQKIppv6VQ3tsL3k/s1600/10537448_1444175129202343_7652802320497538198_n.jpg', '["معركة قادش", "بناء معبد أبو سمبل", "تشييد الرامسيوم", "توسيع الإمبراطورية"]'),
('رمسيس الثالث', 'الدولة الحديثة (الأسرة العشرون)', '1186–1155 ق.م', 'آخر الفراعنة العظام، دافع عن مصر ضد غزوات شعوب البحر وبنى معبد هابو في طيبة.', 'وادي الملوك', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhQQDo91_3Ag3eLHJHGQ7S0mQAst-tGU_8jmFiGQI1n7-4hlAveUTqCFG3DVlReRE02HYyaI38BNkVRnNx9JoTJoJyFhHNJeW-CeX1r1E8yrr03u_k7No3pp7ptPfYiozFELF_1avgSeF0/s1600/1610728593625512-1.png', '["الدفاع عن مصر ضد شعوب البحر", "بناء معبد هابو", "تنظيم الاقتصاد والإدارة"]'),
('بسماتيك الأول', 'العصر المتأخر (الأسرة السادسة والعشرون)', '664–610 ق.م', 'مؤسس الأسرة السادسة والعشرون، حرر مصر من الاحتلال الآشوري وأعاد ازدهارها الثقافي والاقتصادي.', 'سقارة', 'https://gate.ahram.org.eg/Media/News/2021/7/25/19_2021-637628221971046423-104.jpg', '["تحرير مصر من الآشوريين", "إحياء الفن والعمارة المصرية", "تنشيط التجارة"]'),
('نخت انبو الثاني', 'العصر المتأخر (الأسرة الثلاثون)', '360–342 ق.م', 'آخر فرعون مصري أصلي حكم مصر، قاوم الغزو الفارسي وبنى العديد من المعابد والإصلاحات.', 'غير معروف', 'https://upload.wikimedia.org/wikipedia/commons/c/c2/Head_of_Nectanebo_II-MBA_Lyon_H1701-IMG_0204.jpg', '["مقاومة الغزو الفارسي", "بناء وتجديد المعابد", "الإصلاحات الإدارية"]');

-- إدخال بيانات أسئلة الاختبار
INSERT INTO quiz_questions (question_text_ar, option_a_ar, option_b_ar, option_c_ar, option_d_ar, correct_option, difficulty_level, category, points) VALUES
('ما هو أطول نهر في العالم؟', 'نهر النيل', 'نهر الأمازون', 'نهر المسيسيبي', 'نهر اليانغتسي', 1, 'easy', 'جغرافيا', 10),
('كم عدد الأهرامات الرئيسية في الجيزة؟', '2', '3', '4', '5', 2, 'easy', 'آثار', 10),
('ما اسم الفرعون الذي بنى الهرم الأكبر؟', 'رمسيس الثاني', 'خفرع', 'خوفو', 'توت عنخ آمون', 3, 'easy', 'ملوك', 10),
('أين يقع تمثال أبو الهول؟', 'الأقصر', 'الجيزة', 'أسوان', 'القاهرة', 2, 'easy', 'آثار', 10),
('ما هو اسم أول عاصمة لمصر الموحدة؟', 'طيبة', 'الإسكندرية', 'منف', 'القاهرة', 3, 'easy', 'تاريخ', 10),
('كم عدد عجائب الدنيا السبع القديمة الموجودة في مصر؟', '0', '1', '2', '3', 2, 'easy', 'آثار', 10),
('ما هو اسم أهم إله في الديانة المصرية القديمة؟', 'أوزوريس', 'رع', 'حورس', 'أنوبيس', 2, 'easy', 'ديانة', 10),
('ما هو نوع الكتابة التي استخدمها المصريون القدماء؟', 'الهيروغليفية', 'الهيراطيقية', 'الديموطيقية', 'جميع ما سبق', 4, 'easy', 'لغة', 10),
('من هو الفرعون الطفل؟', 'توت عنخ آمون', 'رمسيس الثاني', 'أخناتون', 'أمنحتب الثالث', 1, 'easy', 'ملوك', 10),
('ما هو الغرض الرئيسي من بناء الأهرامات؟', 'سكن الملوك', 'مقابر للملوك', 'معابد للآلهة', 'مستودعات للحبوب', 2, 'easy', 'آثار', 10),
('كم استغرق بناء الهرم الأكبر؟', '10 سنوات', '20 سنة', '30 سنة', '40 سنة', 2, 'medium', 'آثار', 20),
('من هو الفرعون الذي بنى معبد أبو سمبل؟', 'رمسيس الثاني', 'تحتمس الثالث', 'أمنحتب الثالث', 'حتشبسوت', 1, 'medium', 'ملوك', 20),
('ما هو اسم الزوجة الرئيسية لرمسيس الثاني؟', 'نفرتيتي', 'كليوباترا', 'نفرتاري', 'حتشبسوت', 3, 'medium', 'ملوك', 20),
('في أي عصر عاشت الملكة حتشبسوت؟', 'الدولة القديمة', 'الدولة الوسطى', 'الدولة الحديثة', 'العصر المتأخر', 3, 'medium', 'ملوك', 20),
('ما هو اسم الإله الذي كان على شكل ابن آوى؟', 'حورس', 'أنوبيس', 'ست', 'أوزوريس', 2, 'medium', 'ديانة', 20),
('أين تم اكتشاف مقبرة توت عنخ آمون؟', 'وادي الملوك', 'وادي الملكات', 'سقارة', 'دهشور', 1, 'medium', 'آثار', 20),
('ما هو الاسم الحقيقي لتوت عنخ آمون؟', 'توت عنخ آتون', 'نب خبيرو رع', 'عنخ إسن آمون', 'خبر كا رع', 1, 'medium', 'ملوك', 20),
('كم عدد غرف دفن في الهرم الأكبر؟', '1', '2', '3', '4', 3, 'medium', 'آثار', 20),
('من هو المهندس الذي صمم هرم سقارة المدرج؟', 'حسي رع', 'إمحوتب', 'سنفرو', 'خوفو', 2, 'medium', 'شخصيات', 20),
('ما هو اسم العاصمة التي أسسها أخناتون؟', 'أخيتاتون', 'تل العمارنة', 'كلا الإجابتين', 'لا شيء مما سبق', 3, 'medium', 'تاريخ', 20),
('كم بلغ عدد أبناء رمسيس الثاني؟', '50', '100', '150', '200', 2, 'hard', 'ملوك', 30),
('ما هو اسم المعركة الشهيرة التي خاضها رمسيس الثاني ضد الحيثيين؟', 'قادش', 'مجدو', 'كارنك', 'أبو سمبل', 1, 'hard', 'تاريخ', 30),
('من هو الفرعون الذي حكم مصر لمدة 94 عاماً؟', 'رمسيس الثاني', 'بيبي الثاني', 'أمنحتب الثالث', 'سنوسرت الثالث', 2, 'hard', 'ملوك', 30),
('ما هو اسم أول فرعون مصري؟', 'نارمر', 'مينا', 'كلا الإجابتين', 'خوفو', 3, 'hard', 'ملوك', 30),
('كم بلغ وزن كتلة الحجر المستخدمة في بناء الهرم الأكبر؟', '1-2 طن', '2-5 أطنان', '5-10 أطنان', '10-15 طناً', 2, 'hard', 'آثار', 30),
('ما هو اسم الكتاب الذي كان يرشد المصريين القدماء إلى الحياة الآخرة؟', 'كتاب الموتى', 'كتاب التحنيط', 'كتاب الآخرة', 'كتاب الأرواح', 1, 'hard', 'ديانة', 30),
('من هو الفرعون الذي حاول توحيد الآلهة في إله واحد؟', 'أخناتون', 'توت عنخ آمون', 'رمسيس الثاني', 'حتشبسوت', 1, 'hard', 'ملوك', 30),
('ما هو اسم القارب الشمسي الموجود بجانب الهرم الأكبر؟', 'مركب خوفو', 'مركب رع', 'المركب الجنائزي', 'مركب الشمس', 1, 'hard', 'آثار', 30),
('كم عدد الأعمدة في قاعة الأعمدة الكبرى في معبد الكرنك؟', '122', '134', '144', '154', 2, 'hard', 'آثار', 30),
('من هو الفرعون الذي بنى الهرم الأحمر؟', 'سنفرو', 'خوفو', 'خفرع', 'منقرع', 1, 'hard', 'ملوك', 30);

-- إدخال بيانات الإنجازات
INSERT INTO achievements (name_ar, description_ar, requirement_type, requirement_value, reward_points, icon_class) VALUES
('المستكشف المبتدئ', 'أكمل أول اختبار في المستوى الأول', 'quizzes', 1, 50, 'fas fa-compass'),
('عاشق الآثار', 'احجز 3 رحلات إلى مواقع أثرية مختلفة', 'bookings', 3, 100, 'fas fa-landmark'),
('الخبير الصغير', 'احصل على نسبة 80% أو أكثر في أي اختبار', 'score', 80, 150, 'fas fa-graduation-cap'),
('الرحلة الأولى', 'أكمل أول حجز في التطبيق', 'bookings', 1, 25, 'fas fa-map-marked-alt'),
('سلسلة النجاح', 'أكمل 5 اختبارات متتالية بنجاح', 'streak', 5, 200, 'fas fa-fire'),
('جامع النقاط', 'احصل على 1000 نقطة في الاختبارات', 'score', 1000, 300, 'fas fa-coins'),
('المحفظة الذهبية', 'أضف 500 جنيه إلى محفظتك', 'score', 500, 75, 'fas fa-wallet'),
('المعرفة الواسعة', 'أجب على 50 سؤالاً بشكل صحيح', 'quizzes', 50, 150, 'fas fa-brain'),
('الزائر الدائم', 'احجز 10 رحلات في التطبيق', 'bookings', 10, 500, 'fas fa-passport'),
('أسطورة الفراعنة', 'أكمل جميع المستويات الثلاثة بنسبة 90% أو أكثر', 'score', 90, 1000, 'fas fa-crown');

-- إدخال بيانات المستخدمين المبدئيين (مسؤولين)
INSERT INTO users (username, password_hash, email, full_name, phone_number, user_type, wallet_balance) VALUES
('admin', '$2y$10$YourHashedPasswordHere', 'admin@sphinx.com', 'مدير النظام', '01000000000', 'admin', 10000.00),
('guide1', '$2y$10$YourHashedPasswordHere', 'guide1@sphinx.com', 'مرشد سياحي 1', '01111111111', 'guide', 0.00),
('tourist1', '$2y$10$YourHashedPasswordHere', 'tourist1@example.com', 'سائح تجريبي', '01222222222', 'tourist', 500.00);
-- إجراء لتحديث رصيد المحفظة
DELIMITER //
CREATE PROCEDURE UpdateWalletBalance(
    IN p_user_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_transaction_type ENUM('deposit', 'withdrawal', 'booking_payment', 'refund', 'bonus'),
    IN p_description VARCHAR(255),
    IN p_reference_id VARCHAR(50)
)
BEGIN
    DECLARE current_balance DECIMAL(10,2);
    DECLARE new_balance DECIMAL(10,2);
    DECLARE transaction_id_val INT;
    
    -- الحصول على الرصيد الحالي
    SELECT wallet_balance INTO current_balance FROM users WHERE user_id = p_user_id;
    
    -- حساب الرصيد الجديد بناءً على نوع المعاملة
    CASE p_transaction_type
        WHEN 'deposit' THEN SET new_balance = current_balance + p_amount;
        WHEN 'withdrawal' THEN SET new_balance = current_balance - p_amount;
        WHEN 'booking_payment' THEN SET new_balance = current_balance - p_amount;
        WHEN 'refund' THEN SET new_balance = current_balance + p_amount;
        WHEN 'bonus' THEN SET new_balance = current_balance + p_amount;
    END CASE;
    
    -- التأكد من أن الرصيد غير سالب (للسحب والدفع)
    IF (p_transaction_type IN ('withdrawal', 'booking_payment') AND new_balance < 0) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'رصيد غير كافي';
    END IF;
    
    -- تحديث رصيد المستخدم
    UPDATE users SET wallet_balance = new_balance WHERE user_id = p_user_id;
    
    -- إضافة سجل المعاملة
    INSERT INTO wallet_transactions (
        user_id, transaction_type, amount, description, 
        reference_id, balance_before, balance_after, 
        transaction_status
    ) VALUES (
        p_user_id, p_transaction_type, p_amount, p_description,
        p_reference_id, current_balance, new_balance,
        'completed'
    );
    
    SET transaction_id_val = LAST_INSERT_ID();
    
    -- إرجاع رقم المعاملة والرصيد الجديد
    SELECT transaction_id_val AS transaction_id, new_balance AS new_balance;
END //
DELIMITER ;

-- إجراء لحجز رحلة
DELIMITER //
CREATE PROCEDURE CreateBooking(
    IN p_user_id INT,
    IN p_site_id INT,
    IN p_visit_date DATE,
    IN p_number_of_visitors INT,
    IN p_visitor_type ENUM('egyptian', 'foreign'),
    IN p_total_price DECIMAL(10,2),
    IN p_special_requests TEXT,
    IN p_guide_requested BOOLEAN,
    IN p_transport_requested BOOLEAN,
    IN p_lunch_requested BOOLEAN,
    IN p_photo_service_requested BOOLEAN,
    IN p_payment_method VARCHAR(50)
)
BEGIN
    DECLARE booking_number_val VARCHAR(20);
    DECLARE booking_id_val INT;
    
    -- توليد رقم حجز فريد
    SET booking_number_val = CONCAT('SPHX-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(FLOOR(RAND() * 10000), 4, '0'));
    
    -- إنشاء الحجز
    INSERT INTO bookings (
        booking_number, user_id, site_id, booking_date, visit_date,
        number_of_visitors, visitor_type, total_price, special_requests,
        guide_requested, transport_requested, lunch_requested, 
        photo_service_requested, payment_method
    ) VALUES (
        booking_number_val, p_user_id, p_site_id, CURDATE(), p_visit_date,
        p_number_of_visitors, p_visitor_type, p_total_price, p_special_requests,
        p_guide_requested, p_transport_requested, p_lunch_requested,
        p_photo_service_requested, p_payment_method
    );
    
    SET booking_id_val = LAST_INSERT_ID();
    
    -- إرجاع رقم الحجز
    SELECT booking_id_val AS booking_id, booking_number_val AS booking_number;
END //
DELIMITER ;

-- إجراء لتحديث لوحة المتصدرين
DELIMITER //
CREATE PROCEDURE UpdateLeaderboard()
BEGIN
    -- حذف البيانات القديمة
    DELETE FROM leaderboard;
    
    -- إدراج بيانات جديدة بناءً على نتائج الاختبارات
    INSERT INTO leaderboard (user_id, username, total_score, quizzes_taken, average_percentage, last_quiz_date)
    SELECT 
        u.user_id,
        u.username,
        COALESCE(SUM(qr.score), 0) AS total_score,
        COUNT(qr.result_id) AS quizzes_taken,
        COALESCE(AVG(qr.percentage), 0) AS average_percentage,
        MAX(qr.completed_at) AS last_quiz_date
    FROM users u
    LEFT JOIN quiz_results qr ON u.user_id = qr.user_id
    WHERE u.user_type = 'tourist'
    GROUP BY u.user_id, u.username
    ORDER BY total_score DESC, average_percentage DESC;
    
    -- تحديث المراكز
    SET @rank = 0;
    UPDATE leaderboard 
    SET rank_position = (@rank := @rank + 1)
    ORDER BY total_score DESC, average_percentage DESC;
    
    -- تحديث مستوى الشارات
    UPDATE leaderboard 
    SET badge_level = CASE
        WHEN total_score >= 5000 THEN 'platinum'
        WHEN total_score >= 2000 THEN 'gold'
        WHEN total_score >= 500 THEN 'silver'
        ELSE 'bronze'
    END;
END //
DELIMITER ;

-- إجراء لتسجيل نتائج الاختبار
DELIMITER //
CREATE PROCEDURE SaveQuizResult(
    IN p_user_id INT,
    IN p_quiz_level INT,
    IN p_total_questions INT,
    IN p_correct_answers INT,
    IN p_time_taken_seconds INT
)
BEGIN
    DECLARE v_score INT;
    DECLARE v_percentage DECIMAL(5,2);
    DECLARE v_result_id INT;
    
    -- حساب النقاط (10 نقاط لكل سؤال صحيح)
    SET v_score = p_correct_answers * 10;
    
    -- حساب النسبة المئوية
    SET v_percentage = (p_correct_answers * 100.0) / p_total_questions;
    
    -- حفظ النتيجة
    INSERT INTO quiz_results (
        user_id, quiz_level, total_questions, 
        correct_answers, score, percentage, 
        time_taken_seconds
    ) VALUES (
        p_user_id, p_quiz_level, p_total_questions,
        p_correct_answers, v_score, v_percentage,
        p_time_taken_seconds
    );
    
    SET v_result_id = LAST_INSERT_ID();
    
    -- تحديث الإنجازات
    CALL CheckAchievements(p_user_id);
    
    -- تحديث العملات الافتراضية
    CALL AwardVirtualCurrency(p_user_id, v_score);
    
    -- إرجاع النتيجة
    SELECT v_result_id AS result_id, v_score AS score, v_percentage AS percentage;
END //
DELIMITER ;

-- إجراء للتحقق من الإنجازات
DELIMITER //
CREATE PROCEDURE CheckAchievements(IN p_user_id INT)
BEGIN
    -- الإنجاز: المستكشف المبتدئ
    INSERT IGNORE INTO user_achievements (user_id, achievement_id, progress_current, progress_required, is_unlocked)
    SELECT p_user_id, 1, COUNT(*), 1, TRUE
    FROM quiz_results 
    WHERE user_id = p_user_id
    HAVING COUNT(*) >= 1
    ON DUPLICATE KEY UPDATE 
        progress_current = VALUES(progress_current),
        is_unlocked = TRUE,
        unlocked_at = CASE WHEN is_unlocked = FALSE THEN NOW() ELSE unlocked_at END;
    
    -- الإنجاز: عاشق الآثار
    INSERT IGNORE INTO user_achievements (user_id, achievement_id, progress_current, progress_required, is_unlocked)
    SELECT p_user_id, 2, COUNT(DISTINCT site_id), 3, COUNT(DISTINCT site_id) >= 3
    FROM bookings 
    WHERE user_id = p_user_id AND booking_status = 'confirmed'
    ON DUPLICATE KEY UPDATE 
        progress_current = VALUES(progress_current),
        is_unlocked = VALUES(progress_current) >= progress_required,
        unlocked_at = CASE WHEN VALUES(progress_current) >= progress_required AND is_unlocked = FALSE THEN NOW() ELSE unlocked_at END;
    
    -- الإنجاز: الخبير الصغير
    INSERT IGNORE INTO user_achievements (user_id, achievement_id, progress_current, progress_required, is_unlocked)
    SELECT p_user_id, 3, MAX(percentage), 80, MAX(percentage) >= 80
    FROM quiz_results 
    WHERE user_id = p_user_id
    ON DUPLICATE KEY UPDATE 
        progress_current = GREATEST(progress_current, VALUES(progress_current)),
        is_unlocked = progress_current >= progress_required,
        unlocked_at = CASE WHEN progress_current >= progress_required AND is_unlocked = FALSE THEN NOW() ELSE unlocked_at END;
END //
DELIMITER ;

-- إجراء لمنح العملات الافتراضية
DELIMITER //
CREATE PROCEDURE AwardVirtualCurrency(
    IN p_user_id INT,
    IN p_points_earned INT
)
BEGIN
    DECLARE current_gold INT;
    DECLARE current_xp INT;
    DECLARE current_level INT;
    DECLARE new_xp INT;
    DECLARE level_up BOOLEAN DEFAULT FALSE;
    
    -- الحصول على البيانات الحالية
    SELECT gold_coins, experience_points, level 
    INTO current_gold, current_xp, current_level
    FROM virtual_currency 
    WHERE user_id = p_user_id;
    
    -- إذا لم يكن لديه سجل، إنشاء واحد
    IF current_gold IS NULL THEN
        INSERT INTO virtual_currency (user_id) VALUES (p_user_id);
        SET current_gold = 0;
        SET current_xp = 0;
        SET current_level = 1;
    END IF;
    
    -- حساب XP الجديد (نقاط الاختبار = XP)
    SET new_xp = current_xp + p_points_earned;
    
    -- حساب العملات الذهبية (كل 10 نقاط = 1 عملة ذهبية)
    SET current_gold = current_gold + FLOOR(p_points_earned / 10);
    
    -- حساب المستوى الجديد (كل 1000 XP = مستوى)
    IF FLOOR(new_xp / 1000) > current_level THEN
        SET current_level = FLOOR(new_xp / 1000);
        SET level_up = TRUE;
        -- منح مكافأة مستوى (50 عملة ذهبية لكل مستوى)
        SET current_gold = current_gold + (50 * (current_level - FLOOR(current_xp / 1000)));
    END IF;
    
    -- تحديث البيانات
    UPDATE virtual_currency 
    SET 
        gold_coins = current_gold,
        experience_points = new_xp,
        level = current_level,
        total_earned_coins = total_earned_coins + FLOOR(p_points_earned / 10),
        updated_at = NOW()
    WHERE user_id = p_user_id;
    
    -- إرجاع النتائج
    SELECT 
        current_gold AS new_gold_coins,
        new_xp AS new_experience_points,
        current_level AS new_level,
        level_up AS level_increased,
        FLOOR(p_points_earned / 10) AS gold_earned;
END //
DELIMITER ;
-- مشغل لتحديث عدد الزيارات للموقع
DELIMITER //
CREATE TRIGGER after_booking_confirmed 
AFTER UPDATE ON bookings
FOR EACH ROW
BEGIN
    IF OLD.booking_status != 'confirmed' AND NEW.booking_status = 'confirmed' THEN
        -- زيادة عدد الزيارات للموقع
        UPDATE archaeological_sites 
        SET popularity_score = popularity_score + 1
        WHERE site_id = NEW.site_id;
        
        -- إرسال إشعار تأكيد الحجز
        INSERT INTO notifications (
            user_id, notification_type, title_ar, message_ar, 
            action_url, is_important
        ) VALUES (
            NEW.user_id, 'booking', 
            'تم تأكيد حجزك',
            CONCAT('تم تأكيد حجزك رقم ', NEW.booking_number, ' بتاريخ ', NEW.visit_date),
            CONCAT('/booking/', NEW.booking_id),
            TRUE
        );
    END IF;
END //
DELIMITER ;

-- مشغل لتحديث متوسط التقييم للموقع
DELIMITER //
CREATE TRIGGER after_review_insert 
AFTER INSERT ON reviews
FOR EACH ROW
BEGIN
    DECLARE avg_rating DECIMAL(3,2);
    
    IF NEW.site_id IS NOT NULL THEN
        -- حساب متوسط التقييم الجديد
        SELECT AVG(rating) INTO avg_rating 
        FROM reviews 
        WHERE site_id = NEW.site_id AND is_approved = TRUE;
        
        -- تحديث متوسط التقييم
        UPDATE archaeological_sites 
        SET popularity_score = popularity_score + 5 -- مكافأة إضافية للتقييم
        WHERE site_id = NEW.site_id;
    END IF;
END //
DELIMITER ;

-- مشغل لتسجيل سجل أمني لتغيير كلمة المرور
DELIMITER //
CREATE TRIGGER after_password_change 
AFTER UPDATE ON wallet_security
FOR EACH ROW
BEGIN
    IF OLD.password_hash != NEW.password_hash THEN
        INSERT INTO security_logs (
            user_id, action_type, description, status
        ) VALUES (
            NEW.user_id, 'PASSWORD_CHANGE', 
            'تم تغيير كلمة مرور المحفظة',
            'success'
        );
    END IF;
END //
DELIMITER ;

-- مشغل لتسجيل محاولات تسجيل الدخول الفاشلة
DELIMITER //
CREATE TRIGGER after_failed_wallet_login 
AFTER UPDATE ON wallet_security
FOR EACH ROW
BEGIN
    IF NEW.password_attempts > OLD.password_attempts THEN
        INSERT INTO security_logs (
            user_id, action_type, description, status
        ) VALUES (
            NEW.user_id, 'WALLET_LOGIN_FAILED', 
            CONCAT('محاولة دخول فاشلة إلى المحفظة. المحاولات: ', NEW.password_attempts),
            'failure'
        );
    END IF;
END //
DELIMITER ;
-- استعلام للحصول على إحصائيات الموقع
SELECT 
    (SELECT COUNT(*) FROM users WHERE user_type = 'tourist') AS total_tourists,
    (SELECT COUNT(*) FROM bookings WHERE booking_status = 'confirmed') AS total_bookings,
    (SELECT SUM(total_price) FROM bookings WHERE booking_status = 'confirmed' AND payment_status = 'paid') AS total_revenue,
    (SELECT COUNT(*) FROM quiz_results) AS total_quizzes,
    (SELECT AVG(percentage) FROM quiz_results) AS average_quiz_score,
    (SELECT name_ar FROM archaeological_sites ORDER BY popularity_score DESC LIMIT 1) AS most_popular_site;

-- استعلام للحصول على بيانات حجز مستخدم معين
SELECT 
    b.booking_number,
    s.name_ar AS site_name,
    b.visit_date,
    b.number_of_visitors,
    b.total_price,
    b.booking_status,
    b.payment_status
FROM bookings b
JOIN archaeological_sites s ON b.site_id = s.site_id
WHERE b.user_id = 1
ORDER BY b.visit_date DESC;

-- استعلام للحصول على رصيد المحفظة وحركاتها
SELECT 
    u.username,
    u.wallet_balance,
    COUNT(wt.transaction_id) AS total_transactions,
    SUM(CASE WHEN wt.transaction_type IN ('deposit', 'refund', 'bonus') THEN wt.amount ELSE 0 END) AS total_deposits,
    SUM(CASE WHEN wt.transaction_type IN ('withdrawal', 'booking_payment') THEN wt.amount ELSE 0 END) AS total_withdrawals
FROM users u
LEFT JOIN wallet_transactions wt ON u.user_id = wt.user_id
WHERE u.user_id = 1
GROUP BY u.user_id;

-- استعلام للحصول على أفضل 10 متصدرين
SELECT 
    rank_position AS الترتيب,
    username AS اسم_المستخدم,
    total_score AS إجمالي_النقاط,
    quizzes_taken AS عدد_الاختبارات,
    average_percentage AS متوسط_النسبة,
    CASE badge_level
        WHEN 'platinum' THEN 'بلاتينيوم'
        WHEN 'gold' THEN 'ذهبي'
        WHEN 'silver' THEN 'فضي'
        ELSE 'برونزي'
    END AS المستوى
FROM leaderboard
ORDER BY rank_position
LIMIT 10;

-- استعلام للحصول على إحصائيات الشهر الحالي
SELECT 
    DATE(visit_date) AS تاريخ_الزيارة,
    COUNT(*) AS عدد_الحجوزات,
    SUM(number_of_visitors) AS إجمالي_الزوار,
    SUM(total_price) AS إجمالي_الإيرادات
FROM bookings
WHERE booking_status = 'confirmed'
    AND MONTH(visit_date) = MONTH(CURRENT_DATE())
    AND YEAR(visit_date) = YEAR(CURRENT_DATE())
GROUP BY DATE(visit_date)
ORDER BY تاريخ_الزيارة;

-- استعلام للبحث في المعالم الأثرية
SELECT 
    site_id,
    name_ar AS الاسم,
    location_ar AS الموقع,
    era_ar AS العصر,
    foreign_price AS سعر_الأجانب,
    egyptian_price AS سعر_المصريين,
    visiting_hours_ar AS مواعيد_الزيارة
FROM archaeological_sites
WHERE name_ar LIKE '%هرم%'
    OR location_ar LIKE '%جيزة%'
    OR description_ar LIKE '%فرعون%'
ORDER BY popularity_score DESC;
-- فهارس إضافية للأداء
CREATE INDEX idx_bookings_status_date ON bookings(booking_status, visit_date);
CREATE INDEX idx_transactions_user_date ON wallet_transactions(user_id, transaction_date DESC);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read, sent_at DESC);
CREATE INDEX idx_reviews_site_date ON reviews(site_id, created_at DESC);
CREATE INDEX idx_quiz_results_user_level ON quiz_results(user_id, quiz_level, completed_at DESC);
CREATE INDEX idx_leaderboard_score ON leaderboard(total_score DESC);
CREATE INDEX idx_educational_content_featured ON educational_content(is_featured, published_at DESC);
CREATE INDEX idx_virtual_tours_active ON virtual_tours(is_active, views_count DESC);
-- استعلام للحصول على إحصائيات الموقع
SELECT 
    (SELECT COUNT(*) FROM users WHERE user_type = 'tourist') AS total_tourists,
    (SELECT COUNT(*) FROM bookings WHERE booking_status = 'confirmed') AS total_bookings,
    (SELECT SUM(total_price) FROM bookings WHERE booking_status = 'confirmed' AND payment_status = 'paid') AS total_revenue,
    (SELECT COUNT(*) FROM quiz_results) AS total_quizzes,
    (SELECT AVG(percentage) FROM quiz_results) AS average_quiz_score,
    (SELECT name_ar FROM archaeological_sites ORDER BY popularity_score DESC LIMIT 1) AS most_popular_site;

-- استعلام للحصول على بيانات حجز مستخدم معين
SELECT 
    b.booking_number,
    s.name_ar AS site_name,
    b.visit_date,
    b.number_of_visitors,
    b.total_price,
    b.booking_status,
    b.payment_status
FROM bookings b
JOIN archaeological_sites s ON b.site_id = s.site_id
WHERE b.user_id = 1
ORDER BY b.visit_date DESC;

-- استعلام للحصول على رصيد المحفظة وحركاتها
SELECT 
    u.username,
    u.wallet_balance,
    COUNT(wt.transaction_id) AS total_transactions,
    SUM(CASE WHEN wt.transaction_type IN ('deposit', 'refund', 'bonus') THEN wt.amount ELSE 0 END) AS total_deposits,
    SUM(CASE WHEN wt.transaction_type IN ('withdrawal', 'booking_payment') THEN wt.amount ELSE 0 END) AS total_withdrawals
FROM users u
LEFT JOIN wallet_transactions wt ON u.user_id = wt.user_id
WHERE u.user_id = 1
GROUP BY u.user_id;

-- استعلام للحصول على أفضل 10 متصدرين
SELECT 
    rank_position AS الترتيب,
    username AS اسم_المستخدم,
    total_score AS إجمالي_النقاط,
    quizzes_taken AS عدد_الاختبارات,
    average_percentage AS متوسط_النسبة,
    CASE badge_level
        WHEN 'platinum' THEN 'بلاتينيوم'
        WHEN 'gold' THEN 'ذهبي'
        WHEN 'silver' THEN 'فضي'
        ELSE 'برونزي'
    END AS المستوى
FROM leaderboard
ORDER BY rank_position
LIMIT 10;

-- استعلام للحصول على إحصائيات الشهر الحالي
SELECT 
    DATE(visit_date) AS تاريخ_الزيارة,
    COUNT(*) AS عدد_الحجوزات,
    SUM(number_of_visitors) AS إجمالي_الزوار,
    SUM(total_price) AS إجمالي_الإيرادات
FROM bookings
WHERE booking_status = 'confirmed'
    AND MONTH(visit_date) = MONTH(CURRENT_DATE())
    AND YEAR(visit_date) = YEAR(CURRENT_DATE())
GROUP BY DATE(visit_date)
ORDER BY تاريخ_الزيارة;

-- استعلام للبحث في المعالم الأثرية
SELECT 
    site_id,
    name_ar AS الاسم,
    location_ar AS الموقع,
    era_ar AS العصر,
    foreign_price AS سعر_الأجانب,
    egyptian_price AS سعر_المصريين,
    visiting_hours_ar AS مواعيد_الزيارة
FROM archaeological_sites
WHERE name_ar LIKE '%هرم%'
    OR location_ar LIKE '%جيزة%'
    OR description_ar LIKE '%فرعون%'
ORDER BY popularity_score DESC;
-- نسخ احتياطي يومي
CREATE EVENT daily_backup
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO backup_history (backup_type, file_path, backup_status)
    VALUES ('daily', CONCAT('/backups/sphinx_', DATE_FORMAT(NOW(), '%Y%m%d'), '.sql'), 'in_progress');
    
    -- هنا سيتم تنفيذ أمر mysqldump الفعلي
    -- SET @backup_cmd = CONCAT('mysqldump -u root -p sphinx_tours > /backups/sphinx_', DATE_FORMAT(NOW(), '%Y%m%d'), '.sql');
    -- PREPARE stmt FROM @backup_cmd;
    -- EXECUTE stmt;
    
    UPDATE backup_history 
    SET backup_status = 'success', 
        completed_at = NOW(),
        notes = 'نسخ احتياطي يومي تلقائي'
    WHERE backup_id = LAST_INSERT_ID();
END;
-- إنشاء مستخدمين للوصول إلى قاعدة البيانات
CREATE USER 'sphinx_app'@'localhost' IDENTIFIED BY 'StrongPassword123!';
CREATE USER 'sphinx_admin'@'localhost' IDENTIFIED BY 'AdminPassword456!';

-- منح صلاحيات لمستخدم التطبيق
GRANT SELECT, INSERT, UPDATE, DELETE ON sphinx_tours.* TO 'sphinx_app'@'localhost';
GRANT EXECUTE ON PROCEDURE sphinx_tours.UpdateWalletBalance TO 'sphinx_app'@'localhost';
GRANT EXECUTE ON PROCEDURE sphinx_tours.CreateBooking TO 'sphinx_app'@'localhost';
GRANT EXECUTE ON PROCEDURE sphinx_tours.SaveQuizResult TO 'sphinx_app'@'localhost';

-- منح صلاحيات للمسؤول
GRANT ALL PRIVILEGES ON sphinx_tours.* TO 'sphinx_admin'@'localhost';
GRANT CREATE USER, GRANT OPTION ON *.* TO 'sphinx_admin'@'localhost';

-- تطبيق الصلاحيات
FLUSH PRIVILEGES;