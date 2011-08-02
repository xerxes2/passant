import Qt 4.7
import com.nokia.meego 1.0

PageStackWindow {
    id: rootWindow
    property variant root: mainObject
    showStatusBar: false
    width: 848
    height: 480

    initialPage: Page {
        id: mainPage
        orientationLock: PageOrientation.LockLandscape

        Main {
            id: mainObject
            anchors.fill: parent
        }
    }
}
