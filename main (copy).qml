import QtQuick 2.9
import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2


Window {
    id: window
    visible: true
    width: 1024
    height: 768
    color: "#894b06" //brown
    title: qsTr("Bejeweled")
    property var dlist: ["qrc:/Img/Blue1.png","qrc:/Img/Green2.png","qrc:/Img/Orange3.png","qrc:/Img/Purple4.png","qrc:/Img/Red5.png","qrc:/Img/White6.png","qrc:/Img/Yellow7.png"]
    property int firstPick: -1
    property int secondPick: -1
    property int score: 0
    property int del_under: 0
    property var mlist:[]
    property var oldindex:[]
    property var droplist:[]
    property bool lock: false
    property var shuffleLeft: 5
    property var oldScore: 0
    property var bonus:0
    signal startAnimation(var pos)


    function uniq(arr) {
        if(arr===undefined){
            return 1
        }
        var seen = {};
        var ret_arr = [];
        for (var i = 0; i < arr.length; i++) {
            for(var k=0; k < arr[i].length; k++){
            if (!(arr[i][k] in seen)) {
                ret_arr.push(arr[i][k]);
                seen[arr[i][k]] = true;
            }
            }
        }
        return ret_arr;

    }
    function convertIndexToLocation(index){
        var location = []
        location[0] = index % gridBg.columns
        location[1] = Math.floor(index / gridBg.columns)
        return location
    }
    function drop(index)
    {
        if(mlist===undefined){
            return -1
        }
        var cdrop=0
//        console.log("----",uniq(mlist).length)
        for(var t=0;t<uniq(mlist).length;t++){
            if(uniq(mlist)[t]>index && uniq(mlist)[t]%gridBg.columns===index%gridBg.columns){
                cdrop++
            }
        }
        return cdrop
    }

    function resetGame(){
        var i,j
        score=0
        shuffleLeft=5
        timebar.value=60
        firstPick = -1
        secondPick = -1
        for(i=0;i<gridBg.rows;i++)
        {
            for(j=0;j<gridBg.columns;j++){
//                console.log(gridBg.columns*i+j)
                rpItem.itemAt(gridBg.columns*i+j).children[0].source=dlist[Math.floor(Math.random()*dlist.length)]
                rpItem.itemAt(gridBg.columns*i+j).children[0].opacity=1
            }
        }
    }

    function checkIndexInList(index){
//        for(var l=0;l<uniq(mlist).length;l++){
//            if(uniq(mlist)[l] === index){
//                return true
//            }
//        }
        for(var l=0;l<droplist.length;l++){
            if(droplist[l] === index){
                return true
            }
        }
        return false
    }

    function runAllAnimaion(){
        var listAnimation = []
        for(var t=0;t<droplist.length;t++){
            listAnimation.push(droplist[t])
        }
        for(var l=0;l<listAnimation.length;l++){
            window.startAnimation(listAnimation[l])
        }
        window.lock = false
    }
    Rectangle {
        id: playzone
        width: 700
        height: 700
        z:1
        color: "gray"
        border.color: "black"
        border.width: 5
        radius: 10
        anchors.top:parent.top
        anchors.right:parent.right
        anchors.topMargin:10
        anchors.rightMargin:10
        GridLayout {
            id: gridBg
            columns: 9
            rows: 9
            rowSpacing: 0
            columnSpacing: 0
            width: playzone.width- 2*playzone.border.width
            height: playzone.height- 2*playzone.border.width
            anchors.centerIn: parent
            Repeater{
                id: rpItem
                model: gridBg.rows * gridBg.columns
                Rectangle{
                    id: rect1
                    width: gridBg.width/ gridBg.columns
                    height: gridBg.height / gridBg.rows
                    color: index % 2 === 0 ? "#D5D8DC" : "#6E2C00"
                    border.color: "black"
                    Image {
                        id: imageI
                        property bool startAni: false
                        readonly property int self_index: index
                        source: dlist[Math.floor(Math.random()*dlist.length)]
                        sourceSize.width: parent.width*0.8
                        sourceSize.height: parent.height*0.8
                        fillMode: Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 6
                        Connections{
                            target: window
                            ignoreUnknownSignals: true
                            onStartAnimation:{
                                if(pos !== imageI.self_index) return
//                                console.log("checkIndexInList",checkIndexInList(imageI.self_index), "index", imageI.self_index, !imageI.startAni)
                                if(!imageI.startAni && checkIndexInList(imageI.self_index)){ // dieu kien  nay bi sai, chay co 1 lan
//                                    console.log("drop(index)", drop(index), "index",imageI.self_index, "uniq", uniq(mlist), "droplist", droplist)
                                    imageI.startAni = true
                                }
                            }
                        }
                        NumberAnimation {
                            target: imageI
                            property: "y"
//                            from: checkIndexInList(imageI.self_index) ? -50: 6
                            /*((index-oldindex)/gridBg.columns)*rect1.height*/
                            from: -((index-oldindex[index])/gridBg.columns)*rect1.height
                            to: 6
                            duration: (index-oldindex[index])/gridBg.columns > 0 ? 2000*((index-oldindex[index])/gridBg.columns) : 1
                            easing.type: Easing.Linear;
                            running: imageI.startAni

                            onStarted: {
                                  console.log(-((index-oldindex[index])/gridBg.columns)*rect1.height)
    //                            imageI.anchors.centerIn = undefined
                            }
                            onStopped: {
                                imageI.startAni = false // khong reset bien nay ve flase
                                console.log("Stoped")

    //                                imageI.anchors.centerIn = rect1
                            }

                        }
                        onSourceChanged: {
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onReleased:{
                            if(firstPick === -1){
                                firstPick = index
                                rpItem.itemAt(index).children[0].opacity=0.5
                            }
                            else if(secondPick === -1){
                                secondPick = index
                                rpItem.itemAt(index).children[0].opacity=0.5
                            }
                        }
                    }
                }
            }
        }
    }


    Timer{
        id: checkPick
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            if(firstPick === -1 || secondPick === -1) return

            if(secondPick===firstPick-1||secondPick===firstPick+1||secondPick===firstPick-9||secondPick===firstPick+9)
            {

                var item1 = rpItem.itemAt(firstPick).children[0].source
                rpItem.itemAt(firstPick).children[0].source = rpItem.itemAt(secondPick).children[0].source
                rpItem.itemAt(secondPick).children[0].source = item1
                rpItem.itemAt(firstPick).children[0].opacity=1
                rpItem.itemAt(secondPick).children[0].opacity=1
                firstPick = -1
                secondPick = -1
            }
            firstPick = -1
            secondPick = -1
            checkrow.running = true
        }
    }
    Timer{
        id: checkrow
        interval: 200
        running: true
        repeat: true
        triggeredOnStart:false
        onTriggered: {

            // if not checkrow return
            if(window.lock) return
            var checkdeleterow=false
            var rmatch=0
            var cmatch=0
            var i,j,w,u
            var temp=[]
            var tempcol=[]
            var del_arr=[]
            var empty=false


//CHECKROW
            for(i=0;i<gridBg.rows;i++){
                for(j=2;j<gridBg.columns ;j++){
                   if(rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*i+j-1).children[0].source&&
                     rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*i+j-2).children[0].source&&
                     rpItem.itemAt(gridBg.columns*i+j).children[0].source!==""){

                    rmatch=3
                    if(gridBg.columns*i+j%gridBg.columns<gridBg.columns-1){
                    if(rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*i+j+1).children[0].source){
                        rmatch=4
//                                rpItem.itemAt(gridBg.columns*i+j).children[0].source=""
                        if(gridBg.columns*i+j<gridBg.columns-2){
                        if(rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*i+j+2).children[0].source)
                        {
                            rmatch=5
                        }
                        }
                       }
                   }
                    if(rmatch===3)
                   {
                       if(empty===false){
                       mlist=[]
                       }
                       temp = [gridBg.columns*i+j, gridBg.columns*i+j-1,gridBg.columns*i+j-2]
                       mlist.push(temp)
                       rmatch=0

                       empty=true
                   }
                    else if(rmatch===4)
                           {
                               if(empty===false){
                               mlist=[]
                               }
                               temp = [gridBg.columns*i+j, gridBg.columns*i+j-1,gridBg.columns*i+j-2,gridBg.columns*i+j+1]
                               mlist.push(temp)
                               rmatch=0
                               empty=true
                           }
                    else if(rmatch===5)
                           {
                               if(empty===false){
                               mlist=[]
                               }
                               temp = [gridBg.columns*i+j, gridBg.columns*i+j-1,gridBg.columns*i+j-2,gridBg.columns*i+j+1,gridBg.columns*i+j+2]
                               mlist.push(temp)
                               rmatch=0
                               empty=true
                           }
                   }
                }
             }
//CHECKCOL
            for(j=0;j<gridBg.columns;j++){
                for(i=2;i<gridBg.rows ;i++){
                   if(rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*i+j-gridBg.columns).children[0].source&&
                     rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*i+j-gridBg.columns*2).children[0].source&&
                     rpItem.itemAt(gridBg.columns*i+j).children[0].source!=="")
                   {
                           cmatch=3
                           if(Math.floor(gridBg.columns*i+j)/gridBg.columns<gridBg.rows-2){
                           if(rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*i+j+gridBg.columns).children[0].source)
                           {
                                cmatch=4
//                                rpItem.itemAt(gridBg.columns*i+j).children[0].source=""
                                if(Math.floor((gridBg.columns*i+j)/gridBg.columns)<gridBg.rows-3){
                                if(rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*i+j+gridBg.columns*2).children[0].source)
                                {
                                    cmatch=5
                                }
                                }
                           }

                           }
                    if(cmatch===3)
                           {    
                               cmatch=0
                               if(empty===false){
                               mlist=[]
                               }
                               temp = [gridBg.columns*i+j, gridBg.columns*i+j-gridBg.columns,gridBg.columns*i+j-gridBg.columns*2]
                               mlist.push(temp)
                               empty=true
                           }
                    else if(cmatch===4)
                           {     
                               cmatch=0
                               if(empty===false){
                               mlist=[]
                               }
                               temp = [gridBg.columns*i+j, gridBg.columns*i+j-gridBg.columns,gridBg.columns*i+j-gridBg.columns*2,gridBg.columns*i+j+gridBg.columns]
                               mlist.push(temp)
                               empty=true
                           }
                    else if(cmatch===5)
                           {
                               cmatch=0
                               if(empty===false){
                               mlist=[]
                               }
                               temp = [gridBg.columns*i+j, gridBg.columns*i+j-gridBg.columns,gridBg.columns*i+j-gridBg.columns*2,gridBg.columns*i+j+gridBg.columns,gridBg.columns*i+j+gridBg.columns*2]
                               mlist.push(temp)
                               empty=true
                           }
                   }
                }
             }
//Endcheck
            if(empty){
            oldindex=[]
            droplist=[]
            for(u = 0;u<gridBg.columns;u++){
                del_arr[u]=0
            }
//DeleteMatch
            for(var t=0;t<mlist.length;t++){
                for(var k=0; k < mlist[t].length; k++){
                    if(String(rpItem.itemAt(mlist[t][k]).children[0].source)!==""){
                        rpItem.itemAt(mlist[t][k]).children[0].source=""
                        del_arr[mlist[t][k] % gridBg.columns]++
                        score+=1
                    }
                }
            }
            if(score-oldScore>3){
                bonus=10
                score+=10
            }
            oldScore
//Save old index location in new matrix
            var z
            var d
            for(j=0;j<gridBg.columns;j++){
                z=del_arr[j]
                d=0
                for(i=0;i<gridBg.rows;i++)
                {
                    if(String(rpItem.itemAt(gridBg.columns*i+j).children[0].source)!==String("")){
                        oldindex[gridBg.columns*(i+z)+j]=gridBg.columns*i+j
                    }
                    else{
                        oldindex[gridBg.columns*d+j]=-gridBg.columns*z+j
                        z--
                        d++
                    }
                }
            }
//List drop index
            var x
            for(j=0;j<gridBg.columns;j++){
                x=false
                for(i=gridBg.rows-1;i>=0;i--)
                {
                    if(String(rpItem.itemAt(gridBg.columns*i+j).children[0].source)===String("")&&x===false){
                        x=true
                        droplist.push(gridBg.columns*i+j)
                    }
                    else if(x===true){
                    droplist.push(gridBg.columns*i+j)
                    }
                }
            }
//DropColumns
            for(j=0;j<gridBg.columns;j++)
            {
                for(i=0;i<gridBg.rows;i++)
                {
//                    console.log(String(rpItem.itemAt(gridBg.columns*i+j).children[0].source)!=="")
                    if(String(rpItem.itemAt(gridBg.columns*i+j).children[0].source)!=="")
                    {
                        tempcol.push(rpItem.itemAt(gridBg.columns*i+j).children[0].source)
                    }
                }
                u=gridBg.rows-1
                for(w=tempcol.length-1;w>=0;w--)
                {
                    rpItem.itemAt(gridBg.columns*u+j).children[0].source=tempcol[w]
                    rpItem.itemAt(gridBg.columns*u+j).children[0].y = 6
                    u--
                }
                tempcol=[]
            }

//Random news
            for(j=0;j<gridBg.columns;j++)
            {
                for(i=0;i<gridBg.rows;i++)
                {
                   if(del_arr[j]>0)
                   {
                      rpItem.itemAt(gridBg.columns*i+j).children[0].source=dlist[Math.floor(Math.random()*dlist.length)]
                      del_arr[j]--
                   }
                }
            }
            window.lock =true
            runAllAnimaion()
            }
        }
    }

    Rectangle {
        id:menu
        width: parent.width-30-playzone.width
        height: parent.height-20
        color: "transparent"
        radius: 10
        anchors.top:parent.top
        anchors.left:parent.left
        anchors.margins:10
        Image {
            id:logo
            width: parent.width; height: 150
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Img/logo.png"
            anchors.top:parent.top
            anchors.left:parent.left
        }
        Rectangle {
            id:scorepanel
            width: parent.width
            height: 150
            radius: 10
            color:"#573523"
            anchors.top:logo.bottom
            anchors.left:parent.left
            Rectangle {
                id:scoretext
                width: parent.width
                height: parent.height/3
                color: "transparent"
                radius: 30
                anchors.top:parent.top
                anchors.left:parent.left
                Text {
                    text: "Score"
                    font.family: "Helvetica"
                    font.pointSize: 24
                    color: "red"
                    anchors.centerIn: parent
                }

              }
            Rectangle {
                id:scorenumber
                width: parent.width
                height: parent.height-parent.height/3
                color: "#301A02" //dark brown
                radius: 10
                border.color: "#ebcb99"
                border.width: 5
                anchors.bottom:parent.bottom
                anchors.left:parent.left
                Text {
                    text: score
                    font.family: "Helvetica"
                    font.pointSize: 35
                    color: "white"
                    anchors.centerIn: parent
                }
            }

        }
        Rectangle {
            id:menubutton
            x: 0
            width: parent.width
            height: 110
            color: "#573523"
            radius: 10
            anchors.topMargin: 5
            anchors.top: scorepanel.bottom
            Button {
                id:newgamebt
                text: "New game"
                font.pointSize: 15
                anchors.horizontalCenterOffset: 0
                width:parent.width-20
                height:parent.height/2-10
                focusPolicy: Qt.ClickFocus
                onReleased:{
                    resetGame()
                }

                anchors.top:parent.top
                anchors.topMargin:10
                anchors.horizontalCenter: parent.horizontalCenter
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    opacity: enabled ? 1.0 : 0.3
                    color: parent.down ? "#ce1700" : "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    opacity: enabled ? 1 : 0.3
                    border.width: 1
                    radius: 20
                    color: "gray"
                }
            }
            Button {
                text: "Option 1"
                anchors.horizontalCenterOffset: 0
                width:parent.width/2-20
                height:parent.height/2-20
                focusPolicy: Qt.ClickFocus
                onClicked: model.submit()
                anchors.bottom:parent.bottom
                anchors.bottomMargin:10
                anchors.left:parent.left
                anchors.leftMargin:10
            }
            Button {
                text: "Option 2"
                anchors.horizontalCenterOffset: 0
                width:parent.width/2-20
                height:parent.height/2-20
                anchors.topMargin: 8
                focusPolicy: Qt.ClickFocus
                onClicked: model.submit()
                anchors.bottom:parent.bottom
                anchors.bottomMargin:10
                anchors.right:parent.right
                anchors.rightMargin:10
            }

        }
        Rectangle{
            id:menubutton2
            width: parent.width
            height: parent.height-logo.height-scorepanel.height-menubutton.height-10
            color: "#301A02" //dark brown
            radius: 10
            anchors.top:menubutton.bottom
            anchors.topMargin: 5

        }
        ProgressBar {
            id: timebar
            value: 60
            from: 0
            to: 60
            padding: 2
            anchors.bottom:menu.bottom
            anchors.left:menu.right
            anchors.leftMargin:10
            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 6
                color: "#e6e6e6"
                radius: 5
            }
            contentItem: Item {
                id:greenTimebar
                implicitWidth: playzone.width-60
                implicitHeight: 35
                Rectangle {
                    x: 0
                    y: 0
                    width: timebar.visualPosition * parent.width
                    height: parent.height
                    radius: 5
                    color: "#17a81a"
                }
            }
            Rectangle{
                id: shuffle
                anchors.left: timebar.right
                anchors.leftMargin: 10
                anchors.top: timbar.top
                width: greenTimebar.height
                height: greenTimebar.height
                color: "darkgray"
                border.color: "black"
                border.width: 2
                radius: 30
                Text{
                text: shuffleLeft
                font.family: "Helvetica"
                font.pointSize: 20
                color: "red"
                anchors.centerIn: parent
                }
            }

            onValueChanged: {
                if(Math.floor(value) === 0) {
                    console.log("Time out")
                    popup.open()
                }
            }
        }
        Timer{
            interval: 1000
            repeat: true
            running: true
            onTriggered: {
                timebar.value -=1
                if(timebar.value < 0) running = false
            }
        }
        Button {
            id:bonusbt
            text: "Click for hint!"
            font.pointSize: 20
            anchors.horizontalCenterOffset: 0
            width:250
            height:250
            focusPolicy: Qt.ClickFocus
            onReleased:{
                resetGame()
            }
            anchors.bottom:quitbt.top
            anchors.bottomMargin:10
            anchors.horizontalCenter: parent.horizontalCenter
            contentItem: Text {
                text: parent.text
                font: parent.font
                opacity: enabled ? 1.0 : 0.3
                color: parent.down ? "#ffffff":"#ce1700"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            Text {
                text: bonus
                font: parent.font
                opacity: enabled ? 1.0 : 0.3
                color: "#ffffff"
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.bottom:parent.bottom
            }

            background: Image {
                anchors.fill:parent
                opacity: enabled ? 1 : 0.3
                source: "qrc:/Img/hintball.png"

            }
        }
        Button {
            id: quitbt
            text: "Quit game"
            anchors.horizontalCenterOffset: 0
            width:newgamebt.width
            height:newgamebt.height
            focusPolicy: Qt.ClickFocus
            onClicked:{
                window.close()
            }
            anchors.bottom:parent.bottom
            anchors.bottomMargin:10
            anchors.left:parent.left
            anchors.leftMargin:10
        }
    }
    Popup {
        id: popup
        x: parent.width/2-popup.width/2
        y: parent.height/2-popup.height/2
        width: 700
        height: 400
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        contentItem:Item{
            Rectangle{
                width: 600
                height: 400
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.top:parent.top
                Image {
                    width: 600; height: 400
                    fillMode: Image.PreserveAspectFit
                    anchors.fill:parent
                    source: "qrc:/Img/gameover.png"
                }

            }
            Button {
                text: "Try again"
                anchors.horizontalCenterOffset:0
                width:parent.width/2-20
                height:50
                focusPolicy: Qt.ClickFocus
                onClicked:{
                popup.close()
                resetGame()
                }
                anchors.bottom:parent.bottom
                anchors.bottomMargin:10
                anchors.left:parent.left
                anchors.leftMargin:10

            }
            Button {
                text: "Cancel"
                anchors.horizontalCenterOffset: 0
                width:parent.width/2-20
                height:50
                focusPolicy: Qt.ClickFocus
                onClicked:{
                popup.close()
                }
                anchors.bottom:parent.bottom
                anchors.bottomMargin:10
                anchors.right:parent.right
                anchors.rightMargin:10
            }
        }
    }
}
