import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import "components"

BaseScreen {
    id: sendCoinScreen

    property alias address: receiversAddress.text
    property string amount: ""
    property string fee: ""

    title: qsTr("Send")

    Connections {
        target: GraftClient

        onTransferReceived: {
            sendCoinScreen.state = "beforeSend"
            pushScreen.openPaymentScreen(result, true)
        }
    }

    Component.onCompleted: {
        QuickExchangeModel.clear()
        QuickExchangeModel.add("Fee", "GRF", parseFloat(fee) + parseFloat(amount), true)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.margins: 15
            spacing: 20

            Label {
                Layout.fillWidth: true
                font {
                    pixelSize: 16
                    bold: true
                }
                text: Detector.isPlatform(Platform.IOS | Platform.Desktop) ?
                                              qsTr("Receivers address:") : qsTr("Receivers address")
            }

            Label {
                id: receiversAddress
                Layout.fillWidth: true
                wrapMode: Label.WrapAnywhere
                font.pixelSize: 16
                horizontalAlignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.fillWidth: true
                    font {
                        pixelSize: 16
                        bold: true
                    }
                    text: Detector.isPlatform(Platform.IOS | Platform.Desktop) ? qsTr("Amount:") : qsTr("Amount")
                }

                Label {
                    font.pixelSize: 16
                    text: qsTr("%1\t<b>%2</b>").arg(amount).arg("GRF")
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.fillWidth: true
                    font {
                        pixelSize: 16
                        bold: true
                    }
                    text: Detector.isPlatform(Platform.IOS | Platform.Desktop) ? qsTr("Fee:") : qsTr("Fee")
                }

                Label {
                    font.pixelSize: 16
                    text: qsTr("%1\t<b>%2</b>").arg(fee).arg("GRF")
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        QuickExchangeView {
            id: quickExchangeView
            Layout.preferredHeight: 50
            Layout.fillWidth: true
            Layout.bottomMargin: 15
        }

        WideActionButton {
            id: sendCoinsButton
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.bottomMargin: 15
            Layout.alignment: Qt.AlignBottom
            text: qsTr("Confirm")
            onClicked: {
                GraftClient.transfer(receiversAddress.text, amount)
                sendCoinScreen.state = "afterSend"
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    states: [
        State {
            name: "afterSend"

            PropertyChanges {
                target: busyIndicator
                running: true
            }
            PropertyChanges {
                target: sendCoinScreen
                enabled: false
            }
        },
        State {
            name: "beforeSend"

            PropertyChanges {
                target: busyIndicator
                running: false
            }
            PropertyChanges {
                target: sendCoinScreen
                enabled: true
            }
        }
    ]
}
