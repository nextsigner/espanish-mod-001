import QtQuick 2.0
import  "../../../"
import '../../../Silabas.js' as Sil
Item {
    id: r
    width: app.an
    height: app.al
    property string uSilPlayed: ''
    property int uYContent: 0
    property bool showFailTools: false

    Rectangle{
        id: xRowSetSil
        z:flickableSetSil.z+1
        width: rowSetSil.width+app.fs*0.5
        height: showFailTools?app.fs*2.5:0
        visible: r.showFailTools
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: r.top
        anchors.topMargin: app.fs*0.25
        radius: app.fs*0.25
        color:app.c3
        border.color: app.c2
        border.width: 2
        Row{
            id: rowSetSil
            anchors.centerIn: parent
            spacing: app.fs*0.5
            Text{text:r.uSilPlayed===''?'Seleccionar Sìlaba': r.uSilPlayed;color: app.c2;font.pixelSize: app.fs;anchors.verticalCenter: parent.verticalCenter}
            BotonUX{
                id: botDelSil
                text: '-'
                fontColor: app.c2
                backgroudColor: app.c3
                speed: 100
                clip: false
                onClick: {
                    r.removeSilFail(r.uSilPlayed)
                }
                anchors.verticalCenter: parent.verticalCenter
                Timer{
                    running: true
                    repeat: true
                    interval: 1000
                    onTriggered: {
                        parent.visible=(''+r.uSilPlayed).indexOf('!')>0
                    }
                }
            }
            BotonUX{
                id: botSetMsSil
                text: '+'
                fontColor: app.c2
                backgroudColor: app.c3
                speed: 100
                clip: false
                onClick: {
                    r.addSilFail(r.uSilPlayed)
                }
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    Flickable{
        id: flickableSetSil
        width: gridSil.width
        height: r.height-xRowSetSil.height-app.fs*2
        anchors.horizontalCenter:  r.horizontalCenter
        anchors.top: xRowSetSil.bottom
        anchors.topMargin: app.fs
        contentWidth: gridSil.width
        contentHeight: gridSil.height
        Marco{}
        Grid{
            id: gridSil
            columns: 8
            spacing: app.fs*0.1
            width:  (columns*widthSil)+(spacing*(columns-1))
            anchors.horizontalCenter: parent.horizontalCenter
            property int widthSil: app.fs*4
            Repeater{
                id: repSil
                Item{
                    width: gridSil.widthSil
                    height: app.fs*2+app.fs*0.5
                    BotonUX{
                        anchors.centerIn: parent
                        text: modelData
                        fontColor: parseInt(app.jsonSilabas[modelData][0])===-1?'red':app.c2
                        backgroudColor: parseInt(app.jsonSilabas[modelData][0])===-1?'yellow':app.c3
                        speed: 250
                        clip: false
                        onClick: {
                            r.uSilPlayed=modelData
                            tReqAbierto.v++
                            tReqAbierto.restart()
                            focus= true
                            ms.playSil(modelData)
                        }
                        Timer{
                            id: tReqAbierto
                            running: false
                            repeat: false
                            interval: 500
                            property int v: 0
                            onTriggered: {
                                if(v>=2){
                                    parent.abierto=!parent.abierto
                                }
                                v=0
                            }
                        }
                        property bool abierto: false
                        focus: true
                        Keys.onSpacePressed: {
                            r.addSilFail(modelData)
                        }
                        Keys.onRightPressed: {
                            ms.mp.stop()
                            //sbFrom.value+=1
                        }
                        Keys.onLeftPressed: {
                            ms.mp.stop()
                            //sbFrom.value-=1
                        }
                        Keys.onUpPressed: {
                            ms.mp.stop()
                            //sbTo.value+=1
                        }
                        Keys.onDownPressed: {
                            ms.mp.stop()
                            //sbTo.value-=1
                        }
                        Keys.onReturnPressed:  {
                            //ms.mp.seek(sbFrom.value)
                            //ms.mp.to=sbTo.value
                            ms.mp.play()
                        }
                        Rectangle{
                            id: rect
                            width: parent.width
                            height: parent.height
                            color: 'transparent'
                            border.width: 4
                            border.color: 'yellow'
                            anchors.centerIn: parent
                            visible: parent.abierto
                        }
                        Component.onCompleted: {
                            if((''+modelData).indexOf('!')>0){
                                c1='red'
                                c2='yellow'
                                parent.visible=false
                            }
                        }
                    }
                }
            }
        }
    }
    Timer{
        id: tLoadSils
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            console.log('!Cant Sils: '+Sil.silabas.length)
            if(app.arraySilabas.length!==0){
                repSil.model=app.arraySilabas
                stop()
            }
        }
    }
    Timer{
        id: tYContent
        running: false
        repeat: false
        interval: 2000
        onTriggered: {
            flickableSetSil.contentY=r.uYContent
        }
    }
    Rectangle{
        width: children[0].contentWidth+app.fs
        height: app.fs*3
        anchors.centerIn: r
        opacity: !tLoadSils.running?0.0:1.0
        color: app.c3
        radius: app.fs*0.5
        border.width: 2
        border.color: app.c2
        Behavior on opacity{NumberAnimation{duration:2000}}
        onOpacityChanged: {
            if(opacity===0.0){
                tYContent.start()
            }
        }
        Text{
            id: txtLoadingSils
            text: 'Cargando Sìlabas..'
            color: app.c2
            font.pixelSize: app.fs
            anchors.centerIn: parent
        }
    }
    BotonUX{
        id: botPlay
        text: 'Hablar'
        fontColor: app.c2
        backgroudColor: app.c3
        speed: 100
        clip: false
        onClick: {
            ms.arrayWord=['yo', 'soy', '|', 'el', '|', 'rro', 'bot', '|', 'con', '|', 'la', '|', 'voz', '|', 'de', '|', 'rri', 'car', 'do']
            ms.playSil(ms.arrayWord[0])
        }
        visible:false
        anchors.verticalCenter: r.verticalCenter
    }

    Component.onCompleted: {
        controles.visible=false
    }
    function addSilFail(sil){
        r.uYContent=flickableSetSil.contentY
        var ar=''
        for(var i=0;i<app.arraySilabas.length;i++){
            var s=app.arraySilabas[i]
            if(s!==sil){
                ar+=s+'\n'
            }else{
                ar+=s+'!\n'
                ar+=s+'\n'
            }
        }
        unik.setFile(Sil.silMsLocation+'/sils.txt', ar)
        repSil.model=[]
        app.arraySilabas=[]
        app.arrayMsSils=[]
        Sil.setDataSils()
        tLoadSils.start()
    }
    function removeSilFail(sil){
        r.uYContent=flickableSetSil.contentY
        var ar=''
        var finded=false
        for(var i=0;i<app.arraySilabas.length;i++){
            var s=app.arraySilabas[i]
            if(s!==sil){
                ar+=s+'\n'
            }else{
                if(finded){
                    ar+=s+'\n'
                }
                finded=true
            }
        }
        unik.setFile(Sil.silMsLocation+'/sils.txt', ar)
        repSil.model=[]
        app.arraySilabas=[]
        app.arrayMsSils=[]
        Sil.setDataSils()
        tLoadSils.start()
        r.uSilPlayed=''
    }
}
