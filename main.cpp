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

#include <QtGui/QGuiApplication>
#include <QtQuick/QQuickView>   // 메인 소스 파일의 URL이 주어지면 QML 장면을 자동으로로드하고 표시하는 QQuickWindow 의 편리한 서브 클래스입니다.
#include <QtQml/QQmlEngine>     // QML 컴포넌트를 인스턴스화 합니다.
#include <QtQml/QQmlContext>    // QmlEngine이 인스턴스화 한 QML 구성 요소에 데이터를 노출할 수 있습니다.
#include <QtQuick/QQuickItem>   // QQuickItem은 Qt Quick의 모든 시각적 항목 중 가장 기본적인 항목을 제공합니다.
#include <QLoggingCategory>     // QLoggingCategory는 런타임시 문자열로 식별되는 특정 로깅 범주를 나타냅니다.

//! [0]
#include "appmodel.h"

int main(int argc, char *argv[])
{
    QLoggingCategory::setFilterRules("wapp.*.debug=false"); // 일련의 규칙을 통해 사용할 범주 및 메시지 유형을 구성합니다.
    QGuiApplication application(argc, argv);

    // qml에서 import하여 사용할 수 있게 클래스 버전만들기
    qmlRegisterType<WeatherData>("WeatherInfo", 1, 0, "WeatherData");   // 일기예보 정보를 QML UI 계층에 노출시키기 위해 qmlResigterType() 함수를 사용합니다.
    qmlRegisterType<AppModel>("WeatherInfo", 1, 0, "AppModel");         // 실제 QML 파일을 로드하기 전에 등록하려는 각 유형에 대해 한번씩 호출합니다.

//! [0]
    qRegisterMetaType<WeatherData>();
//! [1]
    const QString mainQmlApp = QStringLiteral("qrc:///weatherinfo.qml");
    QQuickView view;
    view.setSource(QUrl(mainQmlApp));                       // 소스를 url로 설정하고 QML 구성 요소를 로드하고 인스턴스화합니다.
    view.setResizeMode(QQuickView::SizeRootObjectToView);   // SizeRootObjectToView로 설정하면 view는 루트 항목의 크기를 view 크기로 자동 조정합니다.

    QObject::connect(view.engine(), SIGNAL(quit()), qApp, SLOT(quit()));    // QuickView의 engine이 quit() 시그널을 보내면
    view.setGeometry(QRect(100, 100, 360, 640));    // QuickView의 크기 지정
    view.show();    // QuickView 보여주기
    return application.exec();
}
//! [1]
