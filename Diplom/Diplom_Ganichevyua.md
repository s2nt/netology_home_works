
#  Дипломная работа по профессии «Системный администратор» Ганичев Ю.А.

Содержание
==========
* [Задача](#Задача)
* [Инфраструктура](#Инфраструктура)
    * [Сайт](#Сайт)
    * [Мониторинг](#Мониторинг)
    * [Логи](#Логи)
    * [Сеть](#Сеть)
    * [Резервное копирование](#Резервное-копирование)
    * [Дополнительно](#Дополнительно)
* [Выполнение работы](#Выполнение-работы)
* [Критерии сдачи](#Критерии-сдачи)
* [Как правильно задавать вопросы дипломному руководителю](#Как-правильно-задавать-вопросы-дипломному-руководителю) 

---------

## Задача
Ключевая задача — разработать отказоустойчивую инфраструктуру для сайта, включающую мониторинг, сбор логов и резервное копирование основных данных. Инфраструктура должна размещаться в [Yandex Cloud](https://cloud.yandex.com/) и отвечать минимальным стандартам безопасности: запрещается выкладывать токен от облака в git. Используйте [инструкцию](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#get-credentials).

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

## Инфраструктура

Использую terraform apply

![Alt текст](https://github.com/s2nt/netology_home_works/blob/c6becacb86106e37cf401c0fe55a63a1329a745a/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-02%20152637.png)

Проверяю параметрвы созданных ВМ

![Alt текст](https://github.com/s2nt/netology_home_works/blob/c6becacb86106e37cf401c0fe55a63a1329a745a/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-02%20152656.png)

Устанавливаю Ansible на bastion host

![Alt текст](https://github.com/s2nt/netology_home_works/blob/c6becacb86106e37cf401c0fe55a63a1329a745a/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-02%20174944.png)

Содержимое файлы inventory.ini (использовались fqdn имена)

![Alt текст](https://github.com/s2nt/netology_home_works/blob/c6becacb86106e37cf401c0fe55a63a1329a745a/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-02%20185746.png)

Проверяем доступность хостов с помощью Ansible ping

![Alt текст](https://github.com/s2nt/netology_home_works/blob/c6becacb86106e37cf401c0fe55a63a1329a745a/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-02%20185730.png)

### Сайт
Создайте две ВМ в разных зонах, установите на них сервер nginx, если его там нет. ОС и содержимое ВМ должно быть идентичным, это будут наши веб-сервера.

Используйте набор статичных файлов для сайта. Можно переиспользовать сайт из домашнего задания.

Устанавливаем Nginx

![Alt текст](https://github.com/s2nt/netology_home_works/blob/c6becacb86106e37cf401c0fe55a63a1329a745a/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-02%20214427.png)

Создайте [Target Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/target-group), включите в неё две созданных ВМ.

![Alt текст](https://github.com/s2nt/netology_home_works/blob/805e1af838b7b2ab977b8e2bb543dddc4714293b/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20192228.png)

Создайте [Backend Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/backend-group), настройте backends на target group, ранее созданную. Настройте healthcheck на корень (/) и порт 80, протокол HTTP.

![Alt текст](https://github.com/s2nt/netology_home_works/blob/805e1af838b7b2ab977b8e2bb543dddc4714293b/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20192217.png)

Создайте [HTTP router](https://cloud.yandex.com/docs/application-load-balancer/concepts/http-router). Путь укажите — /, backend group — созданную ранее.

![Alt текст](https://github.com/s2nt/netology_home_works/blob/805e1af838b7b2ab977b8e2bb543dddc4714293b/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20192158.png)

Создайте [Application load balancer](https://cloud.yandex.com/en/docs/application-load-balancer/) для распределения трафика на веб-сервера, созданные ранее. Укажите HTTP router, созданный ранее, задайте listener тип auto, порт 80.

![Alt текст](https://github.com/s2nt/netology_home_works/blob/805e1af838b7b2ab977b8e2bb543dddc4714293b/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-02%20214946.png)

Протестируйте сайт
`curl -v <публичный IP балансера>:80` 

![Alt текст](https://github.com/s2nt/netology_home_works/blob/c6becacb86106e37cf401c0fe55a63a1329a745a/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-02%20214704.png)

### Мониторинг
Создайте ВМ, разверните на ней Zabbix. На каждую ВМ установите Zabbix Agent, настройте агенты на отправление метрик в Zabbix. 

![Alt текст](https://github.com/s2nt/netology_home_works/blob/3c380817d2fc4cfe368a595a416f6a076a984f74/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20021039.png)

![Alt текст](https://github.com/s2nt/netology_home_works/blob/3c380817d2fc4cfe368a595a416f6a076a984f74/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20030129.png)

Настройте дешборды с отображением метрик, минимальный набор — по принципу USE (Utilization, Saturation, Errors) для CPU, RAM, диски, сеть, http запросов к веб-серверам. Добавьте необходимые tresholds на соответствующие графики.

![Alt текст](https://github.com/s2nt/netology_home_works/blob/3c380817d2fc4cfe368a595a416f6a076a984f74/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20035436.png)

![Alt текст](https://github.com/s2nt/netology_home_works/blob/3c380817d2fc4cfe368a595a416f6a076a984f74/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20035442.png)

### Логи
Cоздайте ВМ, разверните на ней Elasticsearch. Установите filebeat в ВМ к веб-серверам, настройте на отправку access.log, error.log nginx в Elasticsearch.

![Alt текст](https://github.com/s2nt/netology_home_works/blob/3c380817d2fc4cfe368a595a416f6a076a984f74/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20042622.png)

![Alt текст](https://github.com/s2nt/netology_home_works/blob/3c380817d2fc4cfe368a595a416f6a076a984f74/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20045614.png)

Создайте ВМ, разверните на ней Kibana, сконфигурируйте соединение с Elasticsearch.

![Alt текст](https://github.com/s2nt/netology_home_works/blob/3c380817d2fc4cfe368a595a416f6a076a984f74/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20044414.png)

![Alt текст](https://github.com/s2nt/netology_home_works/blob/b54284c94a737de4922157aca70e7935cf85fc77/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20045828.png)

![Alt текст](https://github.com/s2nt/netology_home_works/blob/8eb1a52c4ff12b1fa20e9f37abe40b511eb8b24c/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20181545.png)

### Сеть
Разверните один VPC. Сервера web, Elasticsearch поместите в приватные подсети. Сервера Zabbix, Kibana, application load balancer определите в публичную подсеть.

Настройте [Security Groups](https://cloud.yandex.com/docs/vpc/concepts/security-groups) соответствующих сервисов на входящий трафик только к нужным портам.

Настройте ВМ с публичным адресом, в которой будет открыт только один порт — ssh.  Эта вм будет реализовывать концепцию  [bastion host]( https://cloud.yandex.ru/docs/tutorials/routing/bastion) . Синоним "bastion host" - "Jump host". Подключение  ansible к серверам web и Elasticsearch через данный bastion host можно сделать с помощью  [ProxyCommand](https://docs.ansible.com/ansible/latest/network/user_guide/network_debug_troubleshooting.html#network-delegate-to-vs-proxycommand) . Допускается установка и запуск ansible непосредственно на bastion host.(Этот вариант легче в настройке)

Правило Bastion host

![Alt текст](https://github.com/s2nt/netology_home_works/blob/3c380817d2fc4cfe368a595a416f6a076a984f74/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20193059.png)

![Alt текст](https://github.com/s2nt/netology_home_works/blob/805e1af838b7b2ab977b8e2bb543dddc4714293b/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-02%20215014.png)

### Резервное копирование
Создайте snapshot дисков всех ВМ. Ограничьте время жизни snaphot в неделю. Сами snaphot настройте на ежедневное копирование.

![Alt текст](https://github.com/s2nt/netology_home_works/blob/805e1af838b7b2ab977b8e2bb543dddc4714293b/Diplom/Screen/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-12-03%20184550.png)

