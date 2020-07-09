/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef APPMODEL_H
#define APPMODEL_H

#include <QtCore/QObject>
#include <QtCore/QString>
#include <QtNetwork/QNetworkReply>
#include <QtQml/QQmlListProperty>

#include <QtPositioning/QGeoPositionInfoSource>

//! [0] WeatherData는 HTTP 서비스에서 가져온 날씨 정보를 나타냅니다. 단순한 데이터 클래스지만 Q_PROPERTY를 사용했습니다.
class WeatherData : public QObject {    // 이 예제의 핵심 부분 ★★★ (WeatherData 클래스에 포함된 응용 프로그램의 데이터 모델)
    Q_OBJECT
    Q_PROPERTY(QString dayOfWeek    // 요일
               READ dayOfWeek WRITE setDayOfWeek
               NOTIFY dataChanged)
    Q_PROPERTY(QString weatherIcon  // 날씨 아이콘
               READ weatherIcon WRITE setWeatherIcon
               NOTIFY dataChanged)
    Q_PROPERTY(QString weatherDescription   // 날씨 설명
               READ weatherDescription WRITE setWeatherDescription
               NOTIFY dataChanged)
    Q_PROPERTY(QString temperature  // 온도
               READ temperature WRITE setTemperature
               NOTIFY dataChanged)

public:
    explicit WeatherData(QObject *parent = 0);
    WeatherData(const WeatherData &other);

    QString dayOfWeek() const;
    QString weatherIcon() const;
    QString weatherDescription() const;
    QString temperature() const;

    void setDayOfWeek(const QString &value);
    void setWeatherIcon(const QString &value);
    void setWeatherDescription(const QString &value);
    void setTemperature(const QString &value);

signals:
    void dataChanged();
//! [0]
private:
    QString m_dayOfWeek;
    QString m_weather;
    QString m_weatherDescription;
    QString m_temperature;
//! [1]
};
//! [1]

Q_DECLARE_METATYPE(WeatherData)

class AppModelPrivate;
//! [2] AppModel은 전체 애플리케이션의 상태를 모델링합니다.
class AppModel : public QObject // 이 예제의 핵심 부분 ★★★ (AppModel 클래스에 포함된 응용 프로그램의 데이터 모델)
{
    Q_OBJECT
    Q_PROPERTY(bool ready
               READ ready
               NOTIFY readyChanged)
    Q_PROPERTY(bool hasSource
               READ hasSource
               NOTIFY readyChanged)
    Q_PROPERTY(bool hasValidCity
               READ hasValidCity
               NOTIFY cityChanged)
    Q_PROPERTY(bool hasValidWeather
               READ hasValidWeather
               NOTIFY weatherChanged)
    Q_PROPERTY(bool useGps
               READ useGps WRITE setUseGps
               NOTIFY useGpsChanged)
    Q_PROPERTY(QString city
               READ city WRITE setCity  // city 변수 값을 읽어올 때 city 함수 실행, 값을 변경할 때 setCity 함수 실행
               NOTIFY cityChanged)  // UI에 이 프로세스를 알리기 위해 새 도시를 사용할 때 cityChanged() 신호가 생성됩니다.
    Q_PROPERTY(WeatherData *weather
               READ weather
               NOTIFY weatherChanged)
    Q_PROPERTY(QQmlListProperty<WeatherData> forecast
               READ forecast
               NOTIFY weatherChanged)   // 날씨가 업데이트 될 때마다 weatherChanged() 신호가 생성됩니다.

public:
    explicit AppModel(QObject *parent = 0);
    ~AppModel();

    bool ready() const;
    bool hasSource() const;
    bool useGps() const;
    bool hasValidCity() const;
    bool hasValidWeather() const;
    void setUseGps(bool value);
    void hadError(bool tryAgain);

    QString city() const;
    void setCity(const QString &value);

    WeatherData *weather() const;
    QQmlListProperty<WeatherData> forecast() const; // 다음 4일간의 예측 날씨가 포함된 일기 예보 정보에 QQmlListProperty를 사용합니다. 이를 통해 QML에서 쉽게 액세스할 수 있습니다.

public slots:
    Q_INVOKABLE void refreshWeather();

//! [2]
private slots:
    void queryCity();
    void networkSessionOpened();
    void positionUpdated(QGeoPositionInfo gpsPos);
    void positionError(QGeoPositionInfoSource::Error e);
    void handleGeoNetworkData(QNetworkReply *networkReply);
    void handleWeatherNetworkData(QNetworkReply *networkReply);
    void handleForecastNetworkData(QNetworkReply *networkReply);

//! [3]
signals:
    void readyChanged();
    void useGpsChanged();
    void cityChanged();
    void weatherChanged();

//! [3]

private:
    AppModelPrivate *d;

//! [4]
};
//! [4]

#endif // APPMODEL_H
