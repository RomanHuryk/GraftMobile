import QtQuick 2.9
import QtQuick.Controls 2.2

MenuItem {
    property alias icon: setMenuLabel.icon
    property alias name: setMenuLabel.name

    padding: 0
    topPadding: 0
    bottomPadding: 0
    contentItem: MenuLabel {
        id: setMenuLabel
    }
}
