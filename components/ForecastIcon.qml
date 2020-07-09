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

// 이 qml은 프로그램의 아래쪽에 보이는 요일별 날씨를 나타내는 부분이다.

import QtQuick 2.0

Item {
    id: top

    property string topText: "Mon"          // 요일
    property string weatherIcon: "01d"      // 날씨아이콘
    property string bottomText: "22*/23*"   // 최저/최고 온도

    Text {  // 요일
        id: dayText
        horizontalAlignment: Text.AlignHCenter
        width: top.width
        text: top.topText

        anchors.top: parent.top
        anchors.topMargin: top.height / 5 - dayText.paintedHeight
        anchors.horizontalCenter: parent.horizontalCenter
    }

    WeatherIcon {   // 날씨 아이콘
        id: icon
        weatherIcon: top.weatherIcon

        property real side: {
            var h = 3 * top.height / 5
            if (top.width < h)
                top.width;
            else
                h;
        }

        width: icon.side
        height: icon.side

        anchors.centerIn: parent
    }

    Text {  // 최저/최고 온도
        id: tempText
        horizontalAlignment: Text.AlignHCenter
        width: top.width
        text: top.bottomText

        anchors.bottom: parent.bottom
        anchors.bottomMargin: top.height / 5 - tempText.paintedHeight
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
