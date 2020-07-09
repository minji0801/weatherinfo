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

import QtQuick 2.0
import "components"
//! [0]
import WeatherInfo 1.0  // qml에서 import하여 사용할 수 있도록 main.cpp에서 클래스 버전을 만들어주었다.

Item {
    id: window  // 메인 화면
//! [0]
    width: 360
    height: 640

    state: "loading"    // 항목의 현재 상태 이름

    states: [   // 항목에 가능한 상태 목록
        State {
            name: "loading" // loading일 때는
            PropertyChanges { target: main; opacity: 0 }    // main을 투명하게
            PropertyChanges { target: wait; opacity: 1 }    // wait을 불투명하게
        },
        State {
            name: "ready"   // ready일 때는
            PropertyChanges { target: main; opacity: 1 }    // main을 불투명하게
            PropertyChanges { target: wait; opacity: 0 }    // main을 투명하게
        }
    ]
//! [1]
    AppModel {
        id: model
        onReadyChanged: {
            if (model.ready)    // AppModel의 ready 변수 값이 true이면
                window.state = "ready"
            else    // AppModel의 ready 변수 값이 false이면
                window.state = "loading"
        }
    }
//! [1]
    Item {  // 로딩창
        id: wait
        anchors.fill: parent

        Text {
            text: "Loading weather data..."
            anchors.centerIn: parent
            font.pointSize: 18
        }
    }

    Item {
        id: main
        anchors.fill: parent

        Column {
            spacing: 6

            anchors {
                fill: parent
                topMargin: 6; bottomMargin: 6; leftMargin: 6; rightMargin: 6
            }

            Rectangle { // 최상단에 위치한 지역 버튼
                width: parent.width
                height: 25
                color: "lightgrey"

                Text {  // 지역이름
                    // 유효한 지역이면 이름 보여주기, 아니면 Unknow location
                    // 그리고 gps를 사용한 현재 위치면 (GPS), 정해진 위치면 빈칸
                    text: (model.hasValidCity ? model.city : "Unknown location") + (model.useGps ? " (GPS)" : "")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {    // 클릭했을 때
                        if (model.useGps) { // 현재 위치 사용하는 거면 (맨 마지막)
                            model.useGps = false
                            model.city = "Brisbane"
                        } else {    // 현재 위치를 사용하지 않으면
                            switch (model.city) {
                            case "Brisbane":
                                model.city = "Oslo" // 다음에 올 지역 이름으로
                                break
                            case "Oslo":
                                model.city = "Helsinki"
                                break
                            case "Helsinki":
                                model.city = "New York"
                                break
                            case "New York":
                                model.useGps = true // true 해준 이유는 맨 마지막인 현재 위치 날씨를 보여주기 위해서
                                break
                            }
                        }
                    }
                }
            }

//! [3]
            BigForecastIcon {   // 큰 날씨 아이콘
                id: current

                width: main.width -12
                height: 2 * (main.height - 25 - 12) / 3

                weatherIcon: (model.hasValidWeather
                          ? model.weather.weatherIcon
                          : "01d")  // 날씨 아이콘 : 유효한 날씨면 현재 날씨에 해당하는 아이콘 보여주기, 아니면 01d(sunny) 아이콘 보여주기
//! [3]
                topText: (model.hasValidWeather
                          ? model.weather.temperature
                          : "??")   // 온도 : 유효한 날씨면 현재 온도 보여주기, 아니면 ?? 보여주기
                bottomText: (model.hasValidWeather
                             ? model.weather.weatherDescription
                             : "No weather data")   // 현재 날씨 설명 : 유효한 날씨면 현재 날씨 설명 보여주기, 아니면 No weather data 해주기

                MouseArea {
                    anchors.fill: parent
                    onClicked: {    // 클릭했을 때
                        model.refreshWeather()  // 현재 날씨 새로고침
                    }
                }
//! [4]
            }
//! [4]

            Row {   // 하단에 위치한 요일별 날씨
                id: iconRow
                spacing: 6

                width: main.width - 12
                height: (main.height - 25 - 24) / 3

                property real iconWidth: iconRow.width / 4 - 10
                property real iconHeight: iconRow.height

                // 총 4개의 요일별 날씨
                ForecastIcon {
                    id: forecast1
                    width: iconRow.iconWidth
                    height: iconRow.iconHeight

                    topText: (model.hasValidWeather ?
                              model.forecast[0].dayOfWeek : "??")   // 유효한 날씨면 요일 보여주기, 아니면 ??
                    bottomText: (model.hasValidWeather ?
                                 model.forecast[0].temperature : "??/??")   // 유효한 날씨면 온도 보여주기, 아니면 ??/??
                    weatherIcon: (model.hasValidWeather ?
                              model.forecast[0].weatherIcon : "01d")    // 유효한 날씨면 날씨 아이콘 보여주기, 아니면 01d(sunny)
                }
                ForecastIcon {
                    id: forecast2
                    width: iconRow.iconWidth
                    height: iconRow.iconHeight

                    topText: (model.hasValidWeather ?
                              model.forecast[1].dayOfWeek : "??")
                    bottomText: (model.hasValidWeather ?
                                 model.forecast[1].temperature : "??/??")
                    weatherIcon: (model.hasValidWeather ?
                              model.forecast[1].weatherIcon : "01d")
                }
                ForecastIcon {
                    id: forecast3
                    width: iconRow.iconWidth
                    height: iconRow.iconHeight

                    topText: (model.hasValidWeather ?
                              model.forecast[2].dayOfWeek : "??")
                    bottomText: (model.hasValidWeather ?
                                 model.forecast[2].temperature : "??/??")
                    weatherIcon: (model.hasValidWeather ?
                              model.forecast[2].weatherIcon : "01d")
                }
                ForecastIcon {
                    id: forecast4
                    width: iconRow.iconWidth
                    height: iconRow.iconHeight

                    topText: (model.hasValidWeather ?
                              model.forecast[3].dayOfWeek : "??")
                    bottomText: (model.hasValidWeather ?
                                 model.forecast[3].temperature : "??/??")
                    weatherIcon: (model.hasValidWeather ?
                              model.forecast[3].weatherIcon : "01d")
                }

            }
        }
    }
//! [2]
}
//! [2]
