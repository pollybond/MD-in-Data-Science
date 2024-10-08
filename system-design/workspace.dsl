workspace {
    name "BlaBlaCar"
    description "Сервис поиска попутчиков"

    !identifiers hierarchical

    model {
        user = person "Пользователь" {
            description "Пользователь приложения"
        }

        blablacar = softwareSystem "BlaBlaCar" {
            description "Система для поиска и организации поездок"

            webApp = container "Web-приложение" {
                description "Позволяет пользователям взаимодействовать с сервисом через браузер"
                technology "React, JavaScript"
            }

            api = container "API Gateway" {
                description "Обеспечивает доступ к бизнес-логике"
                technology "Node.js, Express"
            }

            userDB = container "База данных пользователей" {
                description "Хранит информацию о пользователях"
                technology "PostgreSQL"
            }

            routeDB = container "База данных маршрутов" {
                description "Хранит информацию о маршрутах и поездках"
                technology "MongoDB"
            }

            tripDB = container "База данных поездок" {
                description "Хранит информацию о поездках"
                technology "MongoDB"
            }

            // Взаимодействие пользователя с системой
            user -> webApp "Использует для взаимодействия"
            webApp -> api "Запросы к API"
            api -> userDB "Чтение/Запись данных пользователей"
            api -> routeDB "Чтение/Запись маршрутов"
            api -> tripDB "Чтение/Запись поездок"

            // Основные сценарии использования
            user -> webApp "Создание нового пользователя"
            webApp -> api "POST /users"
            api -> userDB "INSERT INTO users"

            user -> webApp "Поиск пользователя по логину"
            webApp -> api "GET /users?login={login}"
            api -> userDB "SELECT * FROM users WHERE login={login}"

            user -> webApp "Поиск пользователя по маске имени и фамилии"
            webApp -> api "GET /users?name={name}&surname={surname}"
            api -> userDB "SELECT * FROM users WHERE name LIKE {name} AND surname LIKE {surname}"

            user -> webApp "Создание маршрута"
            webApp -> api "POST /routes"
            api -> routeDB "INSERT INTO routes"

            user -> webApp "Получение маршрутов пользователя"
            webApp -> api "GET /users/{userId}/routes"
            api -> routeDB "SELECT * FROM routes WHERE userId={userId}"

            user -> webApp "Создание поездки"
            webApp -> api "POST /trips"
            api -> tripDB "INSERT INTO trips"

            user -> webApp "Подключение пользователей к поездке"
            webApp -> api "POST /trips/{tripId}/users"
            api -> tripDB "UPDATE trips SET users = users + {userId} WHERE tripId={tripId}"

            user -> webApp "Получение информации о поездке"
            webApp -> api "GET /trips/{tripId}"
            api -> tripDB "SELECT * FROM trips WHERE tripId={tripId}"
        }
    }
    
    views {
        themes default

        systemContext blablacar {
            include *
            autolayout lr
        }

        container blablacar {
            include *
            autolayout lr
        }

        dynamic blablacar "createUser" "Создание нового пользователя" {
            user -> blablacar.webApp "Создаёт нового пользователя"
            blablacar.webApp -> blablacar.api "POST /users"
            blablacar.api -> blablacar.userDB "INSERT INTO users"
            autolayout lr
        }

        dynamic blablacar "findUserByLogin" "Поиск пользователя по логину" {
            user -> blablacar.webApp "Ищет пользователя по логину"
            blablacar.webApp -> blablacar.api "GET /users?login={login}"
            blablacar.api -> blablacar.userDB "SELECT * FROM users WHERE login={login}"
            autolayout lr
        }

        dynamic blablacar "findUserByName" "Поиск пользователя по маске имени и фамилии" {
            user -> blablacar.webApp "Ищет пользователя по имени и фамилии"
            blablacar.webApp -> blablacar.api "GET /users?name={name}&surname={surname}"
            blablacar.api -> blablacar.userDB "SELECT * FROM users WHERE name LIKE {name} AND surname LIKE {surname}"
            autolayout lr
        }

        dynamic blablacar "createRoute" "Создание нового маршрута" {
            user -> blablacar.webApp "Создаёт новый маршрут"
            blablacar.webApp -> blablacar.api "POST /routes"
            blablacar.api -> blablacar.routeDB "INSERT INTO routes"
            autolayout lr
        }

        dynamic blablacar "getRoutes" "Получение маршрутов пользователя" {
            user -> blablacar.webApp "Запрашивает маршруты"
            blablacar.webApp -> blablacar.api "GET /users/{userId}/routes"
            blablacar.api -> blablacar.routeDB "SELECT * FROM routes WHERE userId={userId}"
            autolayout lr
        }

        dynamic blablacar "createTrip" "Создание новой поездки" {
            user -> blablacar.webApp "Создаёт новую поездку"
            blablacar.webApp -> blablacar.api "POST /trips"
            blablacar.api -> blablacar.tripDB "INSERT INTO trips"
            autolayout lr
        }

        dynamic blablacar "joinTrip" "Подключение пользователей к поездке" {
            user -> blablacar.webApp "Подключается к поездке"
            blablacar.webApp -> blablacar.api "POST /trips/{tripId}/users"
            blablacar.api -> blablacar.tripDB "UPDATE trips SET users = users + {userId} WHERE tripId={tripId}"
            autolayout lr
        }

        dynamic blablacar "getTrip" "Получение информации о поездке" {
            user -> blablacar.webApp "Запрашивает информацию о поездке"
            blablacar.webApp -> blablacar.api "GET /trips/{tripId}"
            blablacar.api -> blablacar.tripDB "SELECT * FROM trips WHERE tripId={tripId}"
            autolayout lr
        }

        theme default
    }
}