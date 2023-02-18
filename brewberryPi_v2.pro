QT += quick charts xml \
    widgets \
    websockets \
    opengl

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        brewinggraph.cpp \
        countdowntimer.cpp \
        main.cpp \
        max31865.cpp \
        pidcontroller.cpp \
        radialbar.cpp \
        rpicomms.cpp \
        rpidata.cpp \
        rpithreads.cpp \
        websocket.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = 

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Disable debug, info, and warning output in Release profile
#CONFIG(release, debug|release): DEFINES += QT_NO_DEBUG_OUTPUT
#CONFIG(release, debug|release): DEFINES += QT_NO_INFO_OUTPUT
#CONFIG(release, debug|release): DEFINES += QT_NO_WARNING_OUTPUT

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    brewinggraph.h \
    countdowntimer.h \
    max31865.h \
    pidcontroller.h \
    radialbar.h \
    rpicomms.h \
    rpidata.h \
    rpithreads.h \
    websocket.h

CONFIG(debug, debug|release) {
    LIBS += -m32 -Wall
    SOURCES += pigpio.cpp
    HEADERS += pigpio.h
} else {
    LIBS += -Wall -lpigpio -lrt -lpthread
}
