-- 1. قاعدة بيانات المشروع
CREATE DATABASE IF NOT EXISTS sphinx_tours;
USE sphinx_tours;

-- 2. جدول المستخدمين
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(200) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    national_id VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(150),
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- 3. جدول المعالم الأثرية
CREATE TABLE IF NOT EXISTS archaeological_sites (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_ar VARCHAR(200) NOT NULL,
    name_en VARCHAR(200),
    location_ar VARCHAR(200) NOT NULL,
    location_en VARCHAR(200),
    era_ar VARCHAR(100) NOT NULL,
    era_en VARCHAR(100),
    description_ar TEXT NOT NULL,
    description_en TEXT,
    foreign_price DECIMAL(10, 2) NOT NULL,
    egyptian_price DECIMAL(10, 2) NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    egyptian_base_price DECIMAL(10, 2) NOT NULL,
    visiting_hours_ar TEXT NOT NULL,
    visiting_hours_en TEXT,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 4. جدول ملوك مصر
CREATE TABLE IF NOT EXISTS egyptian_kings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_ar VARCHAR(200) NOT NULL,
    name_en VARCHAR(200),
    era_ar VARCHAR(100) NOT NULL,
    era_en VARCHAR(100),
    reign_period_ar VARCHAR(100) NOT NULL,
    reign_period_en VARCHAR(100),
    description_ar TEXT NOT NULL,
    description_en TEXT,
    burial_site_ar VARCHAR(200) NOT NULL,
    burial_site_en VARCHAR(200),
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. جدول إنجازات الملوك
CREATE TABLE IF NOT EXISTS king_achievements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    king_id INT NOT NULL,
    achievement_ar VARCHAR(500) NOT NULL,
    achievement_en VARCHAR(500),
    FOREIGN KEY (king_id) REFERENCES egyptian_kings(id) ON DELETE CASCADE
);

-- 6. جدول المحفظة الإلكترونية
CREATE TABLE IF NOT EXISTS wallets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    balance DECIMAL(15, 2) DEFAULT 0.00,
    wallet_password_hash VARCHAR(255),
    security_question VARCHAR(500),
    security_answer_hash VARCHAR(255),
    is_locked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 7. جدول معاملات المحفظة
CREATE TABLE IF NOT EXISTS wallet_transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    wallet_id INT NOT NULL,
    transaction_type ENUM('deposit', 'withdrawal', 'payment', 'refund', 'transfer') NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    description_ar VARCHAR(500) NOT NULL,
    description_en VARCHAR(500),
    reference_id VARCHAR(100),
    status ENUM('pending', 'completed', 'failed', 'cancelled') DEFAULT 'completed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wallet_id) REFERENCES wallets(id) ON DELETE CASCADE
);

-- 8. جدول الحجوزات
CREATE TABLE IF NOT EXISTS bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    booking_number VARCHAR(50) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    site_id INT NOT NULL,
    booking_date DATE NOT NULL,
    visit_date DATE NOT NULL,
    duration_hours INT NOT NULL,
    number_of_visitors INT NOT NULL,
    visitor_type ENUM('egyptian', 'foreign') NOT NULL,
    total_price DECIMAL(15, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_status ENUM('pending', 'paid', 'refunded', 'cancelled') DEFAULT 'paid',
    booking_status ENUM('confirmed', 'pending', 'cancelled', 'completed') DEFAULT 'confirmed',
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (site_id) REFERENCES archaeological_sites(id) ON DELETE CASCADE
);

-- 9. جدول خدمات الحجز الإضافية
CREATE TABLE IF NOT EXISTS booking_services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    service_name_ar VARCHAR(200) NOT NULL,
    service_name_en VARCHAR(200),
    service_price DECIMAL(10, 2) NOT NULL,
    quantity INT DEFAULT 1,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

-- 10. جدول الاختبارات
CREATE TABLE IF NOT EXISTS quizzes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title_ar VARCHAR(200) NOT NULL,
    title_en VARCHAR(200),
    description_ar TEXT,
    description_en TEXT,
    level INT NOT NULL,
    total_points INT NOT NULL,
    time_limit_minutes INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. جدول أسئلة الاختبار
CREATE TABLE IF NOT EXISTS quiz_questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    quiz_id INT NOT NULL,
    question_text_ar TEXT NOT NULL,
    question_text_en TEXT,
    option1_ar VARCHAR(500) NOT NULL,
    option2_ar VARCHAR(500) NOT NULL,
    option3_ar VARCHAR(500) NOT NULL,
    option4_ar VARCHAR(500) NOT NULL,
    correct_option INT NOT NULL,
    points INT NOT NULL,
    category_ar VARCHAR(100),
    category_en VARCHAR(100),
    explanation_ar TEXT,
    explanation_en TEXT,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

-- 12. جدول نتائج الاختبار
CREATE TABLE IF NOT EXISTS quiz_results (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    quiz_id INT NOT NULL,
    score INT NOT NULL,
    total_questions INT NOT NULL,
    correct_answers INT NOT NULL,
    percentage DECIMAL(5, 2) NOT NULL,
    time_taken_seconds INT,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

-- 13. جدول الإنجازات
CREATE TABLE IF NOT EXISTS achievements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_ar VARCHAR(200) NOT NULL,
    name_en VARCHAR(200),
    description_ar TEXT,
    description_en TEXT,
    icon_class VARCHAR(100),
    points_required INT NOT NULL,
    badge_color VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 14. جدول إنجازات المستخدمين
CREATE TABLE IF NOT EXISTS user_achievements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    achievement_id INT NOT NULL,
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE
);

-- 15. جدول لوحة المتصدرين
CREATE TABLE IF NOT EXISTS leaderboard (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    total_points INT DEFAULT 0,
    quizzes_taken INT DEFAULT 0,
    achievements_count INT DEFAULT 0,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 16. جدول محادثات المساعد الذكي
CREATE TABLE IF NOT EXISTS ai_conversations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    session_id VARCHAR(100) UNIQUE NOT NULL,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP NULL,
    language VARCHAR(10) DEFAULT 'ar'
);

-- 17. جدول رسائل المساعد الذكي
CREATE TABLE IF NOT EXISTS ai_messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    conversation_id INT NOT NULL,
    sender ENUM('user', 'ai') NOT NULL,
    message_text TEXT NOT NULL,
    message_type ENUM('text', 'suggestion', 'feature') DEFAULT 'text',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES ai_conversations(id) ON DELETE CASCADE
);

-- 18. جدول عمليات البحث
CREATE TABLE IF NOT EXISTS search_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    search_query TEXT NOT NULL,
    category VARCHAR(50),
    results_count INT,
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 19. إدخال البيانات الأولية للمعالم الأثرية
INSERT INTO archaeological_sites (name_ar, location_ar, era_ar, description_ar, foreign_price, egyptian_price, base_price, egyptian_base_price, visiting_hours_ar, image_url) VALUES
('المتحف المصري الكبير (GEM)', 'منطقة الأهرامات، الجيزة', 'العصر الحديث (متحف)', 'أحد أكبر وأهم المتاحف الأثرية في العالم...', 1000.00, 300.00, 500.00, 100.00, '9 ص - 5 م', 'https://example.com/gem.jpg'),
('أهرامات الجيزة', 'الجيزة', 'الدولة القديمة (أسرة 4)', 'أشهر معالم مصر، وتضم ثلاثة أهرامات...', 1040.00, 440.00, 440.00, 40.00, '8 ص - 5 م', 'https://example.com/pyramids.jpg');

-- 20. إدخال البيانات الأولية للملوك
INSERT INTO egyptian_kings (name_ar, era_ar, reign_period_ar, description_ar, burial_site_ar, image_url) VALUES
('نارمر (مينا)', 'العصر العتيق (الأسرة الأولى)', 'حوالي 3100 ق.م', 'يعتبر أول ملك لمصر الموحدة...', 'أبيدوس', 'https://example.com/narmer.jpg'),
('خوفو', 'الدولة القديمة (الأسرة الرابعة)', '2589–2566 ق.م', 'ثاني فراعنة الأسرة الرابعة...', 'الهرم الأكبر بالجيزة', 'https://example.com/khufu.jpg');

-- 21. إدخال إنجازات الملوك
INSERT INTO king_achievements (king_id, achievement_ar) VALUES
(1, 'توحيد مصر العليا والسفلى'),
(1, 'تأسيس الأسرة الأولى'),
(2, 'بناء الهرم الأكبر في الجيزة');

-- 22. إنشاء فهارس لتحسين الأداء
CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_bookings_date ON bookings(visit_date);
CREATE INDEX idx_transactions_wallet ON wallet_transactions(wallet_id);
CREATE INDEX idx_quiz_results_user ON quiz_results(user_id);
CREATE INDEX idx_search_history_user ON search_history(user_id);