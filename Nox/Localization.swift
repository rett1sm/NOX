import Foundation

enum NoxLanguage: String, CaseIterable, Identifiable {
    case russian = "ru"
    case ukrainian = "uk"
    case belarusian = "be"
    case english = "en"
    case chinese = "zh-Hans"

    var id: String { rawValue }

    var nativeName: String {
        switch self {
        case .russian: return "Русский"
        case .ukrainian: return "Українська"
        case .belarusian: return "Беларуская"
        case .english: return "English"
        case .chinese: return "简体中文"
        }
    }
}

enum L10n {
    private static let strings: [String: [String: String]] = [
        "tab.home": ["ru":"Главная", "uk":"Головна", "be":"Галоўная", "en":"Home", "zh-Hans":"主页"],
        "tab.tweaks": ["ru":"Твики", "uk":"Твіки", "be":"Твікі", "en":"Tweaks", "zh-Hans":"功能调整"],
        "tab.wallpapers": ["ru":"Обои", "uk":"Шпалери", "be":"Шпалеры", "en":"Wallpapers", "zh-Hans":"壁纸"],
        "tab.passcode": ["ru":"Код-панель", "uk":"Код-панель", "be":"Код-панэль", "en":"Passcode", "zh-Hans":"密码面板"],
        "tab.settings": ["ru":"Настройки", "uk":"Налаштування", "be":"Налады", "en":"Settings", "zh-Hans":"设置"],
        "home.eyebrow": ["ru":"ТВОЙ IPHONE · ТВОИ ПРАВИЛА", "uk":"ТВІЙ IPHONE · ТВОЇ ПРАВИЛА", "be":"ТВОЙ IPHONE · ТВАЕ ПРАВІЛЫ", "en":"YOUR IPHONE · YOUR RULES", "zh-Hans":"你的 iPhone · 你的规则"],
        "home.title": ["ru":"Сделай iPhone\nсвоим.", "uk":"Зроби iPhone\nсвоїм.", "be":"Зрабі iPhone\nсваім.", "en":"Make your iPhone\nyours.", "zh-Hans":"让 iPhone\n成为你的风格。"],
        "home.subtitle": ["ru":"Один центр для оформления и системных настроек.", "uk":"Єдиний центр оформлення та системних налаштувань.", "be":"Адзіны цэнтр афармлення і сістэмных налад.", "en":"One place for your look and system customizations.", "zh-Hans":"统一管理外观与系统自定义。"],
        "home.environment": ["ru":"Среда устройства", "uk":"Середовище пристрою", "be":"Асяроддзе прылады", "en":"Device environment", "zh-Hans":"设备环境"],
        "home.backendPending": ["ru":"Системный модуль ещё не подключён", "uk":"Системний модуль ще не підключено", "be":"Сістэмны модуль яшчэ не падключаны", "en":"System module not connected yet", "zh-Hans":"系统模块尚未连接"],
        "home.quick": ["ru":"Быстрый доступ", "uk":"Швидкий доступ", "be":"Хуткі доступ", "en":"Quick access", "zh-Hans":"快捷入口"],
        "home.respring": ["ru":"Respring", "uk":"Respring", "be":"Respring", "en":"Respring", "zh-Hans":"重新启动界面"],
        "home.respringInfo": ["ru":"Перезапустить SpringBoard", "uk":"Перезапустити SpringBoard", "be":"Перазапусціць SpringBoard", "en":"Restart SpringBoard", "zh-Hans":"重新启动 SpringBoard"],
        "respring.confirmTitle": ["ru":"Выполнить respring?", "uk":"Виконати respring?", "be":"Выканаць respring?", "en":"Perform respring?", "zh-Hans":"执行 Respring？"],
        "respring.confirmBody": ["ru":"Интерфейс iOS перезапустится. Сохрани открытые данные перед продолжением.", "uk":"Інтерфейс iOS перезапуститься. Збережи відкриті дані перед продовженням.", "be":"Інтэрфейс iOS перазапусціцца. Захавай адкрытыя даныя перад працягам.", "en":"The iOS interface will restart. Save open work before continuing.", "zh-Hans":"iOS 界面将重新启动。请先保存未完成的内容。"],
        "common.cancel": ["ru":"Отмена", "uk":"Скасувати", "be":"Скасаваць", "en":"Cancel", "zh-Hans":"取消"],
        "common.continue": ["ru":"Продолжить", "uk":"Продовжити", "be":"Працягнуць", "en":"Continue", "zh-Hans":"继续"],
        "common.save": ["ru":"Сохранить", "uk":"Зберегти", "be":"Захаваць", "en":"Save", "zh-Hans":"保存"],
        "common.preview": ["ru":"Предпросмотр", "uk":"Попередній перегляд", "be":"Папярэдні прагляд", "en":"Preview", "zh-Hans":"预览"],
        "tweaks.title": ["ru":"Кастомизация системы", "uk":"Кастомізація системи", "be":"Кастамізацыя сістэмы", "en":"System customization", "zh-Hans":"系统自定义"],
        "tweaks.subtitle": ["ru":"Модули будут применять изменения через системный backend.", "uk":"Модулі застосовуватимуть зміни через системний backend.", "be":"Модулі будуць ужываць змены праз сістэмны backend.", "en":"Modules apply changes through the system backend.", "zh-Hans":"模块将通过系统后端应用更改。"],
        "tweaks.passcode": ["ru":"Оформление код-панели", "uk":"Оформлення код-панелі", "be":"Афармленне код-панэлі", "en":"Passcode appearance", "zh-Hans":"密码面板外观"],
        "tweaks.icons": ["ru":"Иконки и подписи", "uk":"Іконки та підписи", "be":"Значкі і подпісы", "en":"Icons and labels", "zh-Hans":"图标与标签"],
        "tweaks.lock": ["ru":"Экран блокировки", "uk":"Екран блокування", "be":"Экран блакіроўкі", "en":"Lock screen", "zh-Hans":"锁定屏幕"],
        "tweaks.gestures": ["ru":"Жесты и анимации", "uk":"Жести й анімації", "be":"Жэсты і анімацыі", "en":"Gestures and animations", "zh-Hans":"手势与动画"],
        "tweaks.pending": ["ru":"Backend в разработке", "uk":"Backend у розробці", "be":"Backend у распрацоўцы", "en":"Backend in development", "zh-Hans":"后端开发中"],
        "tweaks.lockDetail": ["ru":"Вид экрана блокировки, виджеты и отступы", "uk":"Вигляд екрана блокування, віджети та відступи", "be":"Выгляд экрана блакіроўкі, віджэты і водступы", "en":"Lock screen layout, widgets and spacing", "zh-Hans":"锁屏布局、小组件与间距"],
        "tweaks.passcodeDetail": ["ru":"Графика и расположение кнопок код-панели", "uk":"Графіка та розташування кнопок код-панелі", "be":"Графіка і размяшчэнне кнопак код-панэлі", "en":"Keypad artwork and button layout", "zh-Hans":"密码键盘图案与按钮布局"],
        "tweaks.iconsDetail": ["ru":"Подписи и системные элементы интерфейса", "uk":"Підписи та системні елементи інтерфейсу", "be":"Подпісы і сістэмныя элементы інтэрфейсу", "en":"Icon labels and system interface details", "zh-Hans":"图标标签与系统界面细节"],
        "tweaks.gesturesDetail": ["ru":"Жесты и переходы SpringBoard", "uk":"Жести та переходи SpringBoard", "be":"Жэсты і пераходы SpringBoard", "en":"SpringBoard gestures and transitions", "zh-Hans":"SpringBoard 手势与转场"],
        "passcode.buttonStyle": ["ru":"Стиль кнопок", "uk":"Стиль кнопок", "be":"Стыль кнопак", "en":"Button style", "zh-Hans":"按钮样式"],
        "passcode.glass": ["ru":"Стекло", "uk":"Скло", "be":"Шкло", "en":"Glass", "zh-Hans":"玻璃"],
        "passcode.soft": ["ru":"Мягкий", "uk":"М'який", "be":"Мяккі", "en":"Soft", "zh-Hans":"柔和"],
        "passcode.solid": ["ru":"Плотный", "uk":"Щільний", "be":"Шчыльны", "en":"Solid", "zh-Hans":"实心"],
        "wallpapers.title": ["ru":"Твоя коллекция", "uk":"Твоя колекція", "be":"Твая калекцыя", "en":"Your collection", "zh-Hans":"你的收藏"],
        "wallpapers.subtitle": ["ru":"Импортируй изображения и видео для будущей интеграции с PosterBoard.", "uk":"Імпортуй зображення та відео для майбутньої інтеграції з PosterBoard.", "be":"Імпартуй выявы і відэа для будучай інтэграцыі з PosterBoard.", "en":"Import images and videos for the upcoming PosterBoard integration.", "zh-Hans":"导入图片和视频，为后续 PosterBoard 集成做准备。"],
        "wallpapers.import": ["ru":"Импортировать обои", "uk":"Імпортувати шпалери", "be":"Імпартаваць шпалеры", "en":"Import wallpapers", "zh-Hans":"导入壁纸"],
        "wallpapers.empty": ["ru":"Пока нет файлов", "uk":"Поки немає файлів", "be":"Пакуль няма файлаў", "en":"No files yet", "zh-Hans":"暂无文件"],
        "passcode.title": ["ru":"Редактор код-панели", "uk":"Редактор код-панелі", "be":"Рэдактар код-панэлі", "en":"Passcode designer", "zh-Hans":"密码面板设计器"],
        "passcode.subtitle": ["ru":"Настрой внешний вид и проверь результат в предпросмотре.", "uk":"Налаштуй вигляд і перевір результат у попередньому перегляді.", "be":"Наладзь выгляд і правер вынік у папярэднім праглядзе.", "en":"Style the keypad and check it in the preview.", "zh-Hans":"自定义键盘样式并查看预览。"],
        "passcode.note": ["ru":"Сейчас сохраняется дизайн предпросмотра. Применение к системной панели подключается отдельно.", "uk":"Зараз зберігається дизайн попереднього перегляду. Застосування до системної панелі підключається окремо.", "be":"Зараз захоўваецца дызайн папярэдняга прагляду. Прымяненне да сістэмнай панэлі падключаецца асобна.", "en":"This saves the visual design preview. Applying it to the system keypad requires a separate backend integration.", "zh-Hans":"目前仅保存设计预览。应用到系统密码键盘需要单独的后端支持。"],
        "settings.appearance": ["ru":"Внешний вид", "uk":"Зовнішній вигляд", "be":"Знешні выгляд", "en":"Appearance", "zh-Hans":"外观"],
        "settings.design": ["ru":"Стиль интерфейса", "uk":"Стиль інтерфейсу", "be":"Стыль інтэрфейсу", "en":"Interface style", "zh-Hans":"界面风格"],
        "design.liquidDetail": ["ru":"Прозрачные слои и мягкое размытие", "uk":"Прозорі шари та м'яке розмиття", "be":"Празрыстыя слаі і мяккае размыццё", "en":"Translucent layers and soft blur", "zh-Hans":"半透明层与柔和模糊"],
        "design.materialDetail": ["ru":"Выразные поверхности и округлые карточки", "uk":"Виразні поверхні та округлі картки", "be":"Выразныя паверхні і круглявыя карткі", "en":"Expressive surfaces and rounded cards", "zh-Hans":"鲜明表面与圆角卡片"],
        "design.oledDetail": ["ru":"Абсолютно чёрный фон и контраст", "uk":"Абсолютно чорний фон і контраст", "be":"Абсалютна чорны фон і кантраст", "en":"Pure black and sharp contrast", "zh-Hans":"纯黑背景与高对比度"],
        "design.minimalDetail": ["ru":"Спокойные поверхности и чистые отступы", "uk":"Спокійні поверхні та чисті відступи", "be":"Спакойныя паверхні і чыстыя водступы", "en":"Quiet surfaces and clean spacing", "zh-Hans":"简洁表面与清晰间距"],
        "settings.accent": ["ru":"Акцентный цвет", "uk":"Акцентний колір", "be":"Акцэнтны колер", "en":"Accent color", "zh-Hans":"强调色"],
        "settings.radius": ["ru":"Скругление карточек", "uk":"Заокруглення карток", "be":"Закругленне картак", "en":"Card radius", "zh-Hans":"卡片圆角"],
        "settings.opacity": ["ru":"Прозрачность", "uk":"Прозорість", "be":"Празрыстасць", "en":"Surface opacity", "zh-Hans":"表面透明度"],
        "settings.language": ["ru":"Язык приложения", "uk":"Мова застосунку", "be":"Мова праграмы", "en":"App language", "zh-Hans":"应用语言"],
        "settings.motion": ["ru":"Анимации интерфейса", "uk":"Анімації інтерфейсу", "be":"Анімацыі інтэрфейсу", "en":"Interface animations", "zh-Hans":"界面动画"],
        "settings.about": ["ru":"О проекте", "uk":"Про проєкт", "be":"Пра праект", "en":"About", "zh-Hans":"关于"],
        "settings.aboutText": ["ru":"Nox — центр персонализации iOS. Системные изменения будут доступны после подключения и проверки backend-модулей.", "uk":"Nox — центр персоналізації iOS. Системні зміни будуть доступні після підключення та перевірки backend-модулів.", "be":"Nox — цэнтр персаналізацыі iOS. Сістэмныя змены будуць даступныя пасля падключэння і праверкі backend-модуляў.", "en":"Nox is an iOS personalization hub. System changes become available after backend modules are integrated and verified.", "zh-Hans":"Nox 是 iOS 个性化中心。系统级更改将在后端模块集成并验证后开放。"]
    ]

    static func text(_ key: String, language: String) -> String {
        strings[key]?[language] ?? strings[key]?["en"] ?? key
    }
}
