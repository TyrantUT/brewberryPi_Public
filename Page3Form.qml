import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.XmlListModel 2.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.15
import Qt.labs.folderlistmodel 2.15
import BreweryGraph 1.0

Page {
    id: page3

    property string recipeName: ""
    property string recipeType: ""
    property string recipeStyle: ""
    property string recipeCategory: ""
    property string recipeCategoryNumber: ""
    property string recipeCategoryLetter: ""
    property string recipeCategoryCombined: ""
    property string bjcpComments: ""
    property string recipeBatchSize: ""
    property string recipeBoilSize: ""
    property real recipeOG: 0.0
    property real recipeFG: 0.0
    property real recipeABV: 0.0
    property real recipeIBU: 0.0
    property real recipeColor: 0
    property real recipeOgMin: 0.0
    property real recipeOgMax: 0.0

    property string fermentableNames: ""
    property string fermentableAmounts: ""
    property string fermentableTypes: ""
    property var fermentables: []

    property string hopNames: ""
    property string hopAmounts: ""
    property string hopUses: ""
    property string hopTimes: ""
    property string hopForms: ""
    property var hops: []

    property string yeastNames: ""
    property string yeastLabs: ""
    property string yeastProducts: ""
    property var yeasts: []  

    property string mashSteps: ""
    property string mashAmounts: ""
    property string mashInfuse: ""
    property string mashTemps: ""
    property var mash: []

    property string bjchStyleGuidelines: ""
    property string folderPath: "qrc:/recipes"
    property string recipeFile: ""

    function convertSRM(srm_color) {
        var srm_number = parseInt(srm_color);
        var srm = [];
        srm[0] = "#FFF4D4";
        srm[1] = "#FFE699";
        srm[2] = "#FFD878";
        srm[3] = "#FFCA5A";
        srm[4] = "#FFBF42";
        srm[5] = "#FBB123";
        srm[6] = "#F8A600";
        srm[7] = "#F39C00";
        srm[8] = "#EA8F00";
        srm[9] = "#E58500";
        srm[10] = "#DE7C00";
        srm[11] = "#D77200";
        srm[12] = "#afCF6900";
        srm[13] = "#CB6200";
        srm[14] = "#C35900";
        srm[15] = "#BB5100";
        srm[16] = "#B54C00";
        srm[17] = "#B04500";
        srm[18] = "#A63E00";
        srm[19] = "#A13700";
        srm[20] = "#9B3200";
        srm[21] = "#952D00";
        srm[22] = "#8E2900";
        srm[23] = "#882300";
        srm[24] = "#821E00";
        srm[25] = "#7B1A00";
        srm[26] = "#771900";
        srm[27] = "#701400";
        srm[28] = "#6A0E00";
        srm[29] = "#660D00";
        srm[30] = "#5E0B00";
        srm[31] = "#5A0A02";
        srm[32] = "#600903";
        srm[33] = "#520907";
        srm[34] = "#4C0505";
        srm[35] = "#470606";
        srm[36] = "#420607";
        srm[37] = "#3D0708";
        srm[38] = "#370607";
        srm[39] = "#2D0607";
        srm[40] = "#1F0506";
        srm[41] = "#000000";

        return srm[srm_number];
    }

    function returnIndexString(string) {
        const stringArray = string.split(";");
        var stringLen = stringArray.length;

        return stringArray;
    }

    function combineStrings(...strings) {
        var tempArray = [];
        for ( let i = 0; i < strings.length; i++) {
            tempArray.push(strings[i].split(";"));
        }

        return tempArray;
    }

    function secondsToTime(value) {
        var date = new Date(null);
        date.setSeconds(Math.round(value * 100) / 100);
        var result = date.toISOString().substr(11, 8);

        return result;
    }

    function readBjcpStyleGuidelines() {
        var xhr = new XMLHttpRequest;

        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status == 200) {
                parseJsonData(xhr.responseText);
            }
        }
        xhr.open("GET", "qrc:/recipes/bjcpStyleGuidelines.json", true);
        xhr.send();
    }

    function parseJsonData(response) {
        var js = JSON.parse(response, function(key, value) {
            return value
        });

        for ( var i = 0; i < Object.keys(js.styleguide.category).length; i++ ) {
            if ( recipeCategoryNumber === js.styleguide.category[i].id ) {

                for ( var d = 0; d < Object.keys(js.styleguide.category[i].subcategory).length; d++) {
                    if ( recipeCategoryCombined === js.styleguide.category[i].subcategory[d].id ) {
                        bjcpComments = js.styleguide.category[i].subcategory[d].comments;
                    }
                }
            }
        }
    }

    XmlListModel {
        id: xmlModel
        query: "/RECIPES"

        XmlRole { name: "NAME"; query: "RECIPE/NAME/string()" }
        XmlRole { name: "TYPE"; query: "RECIPE/TYPE/string()" }
        XmlRole { name: "STYLE"; query: "RECIPE/STYLE/NAME/string()" }
        XmlRole { name: "CATEGORY"; query: "RECIPE/STYLE/CATEGORY/string()" }
        XmlRole { name: "CATEGORY_NUMBER"; query: "RECIPE/STYLE/CATEGORY_NUMBER/string()" }
        XmlRole { name: "STYLE_LETTER"; query: "RECIPE/STYLE/STYLE_LETTER/string()" }

        XmlRole { name: "BATCH_VOLUME"; query: "RECIPE/DISPLAY_BATCH_SIZE/string()" }
        XmlRole { name: "BOIL_VOLUME"; query: "RECIPE/DISPLAY_BOIL_SIZE/string()" }
        XmlRole { name: "BOIL_TIME"; query: "RECIPE/BOIL_TIME/string()" }
        XmlRole { name: "EFFICIENCY"; query: "RECIPE/EFFICIENCY/string()" }
        XmlRole { name: "BATCH_OG"; query: "RECIPE/EST_OG/string()" }
        XmlRole { name: "BATCH_FG"; query: "RECIPE/EST_FG/string()" }
        XmlRole { name: "ABV"; query: "RECIPE/EST_ABV/string()" }
        XmlRole { name: "IBU"; query: "RECIPE/IBU/string()" }
        XmlRole { name: "COLOR"; query: "RECIPE/EST_COLOR/string()" }

        // Hops
        XmlRole { name: "HOP_NAME"; query: "string-join(RECIPE/HOPS/HOP/NAME/string(), ';')" }
        XmlRole { name: "HOP_AMOUNT"; query: "string-join(RECIPE/HOPS/HOP/DISPLAY_AMOUNT/string(), ';')" }
        XmlRole { name: "HOP_USE"; query: "string-join(RECIPE/HOPS/HOP/USE/string(), ';')" }
        XmlRole { name: "HOP_TIME"; query: "string-join(RECIPE/HOPS/HOP/DISPLAY_TIME/string(), ';')" }
        XmlRole { name: "HOP_FORM"; query: "string-join(RECIPE/HOPS/HOP/FORM/string(), ';')" }

        // Fermentable
        XmlRole { name: "FERMENTABLE_NAME"; query: "string-join(RECIPE/FERMENTABLES/FERMENTABLE/NAME/string(), ';')" }
        XmlRole { name: "FERMENTABLE_AMOUNT"; query: "string-join(RECIPE/FERMENTABLES/FERMENTABLE/DISPLAY_AMOUNT/string(), ';')" }
        XmlRole { name: "FERMENTABLE_TYPE"; query: "string-join(RECIPE/FERMENTABLES/FERMENTABLE/TYPE/string(), ';')" }

        // Msc
        XmlRole { name: "MISC_NAME"; query: "string-join(RECIPE/MISCS/MISC/NAME/string(), ';')" }
        XmlRole { name: "MISC_TYPE"; query: "string-join(RECIPE/MISCS/MISC/TYPE/string(), ';')" }
        XmlRole { name: "MISC_USE"; query: "string-join(RECIPE/MISCS/MISC/USE/string(), ';')" }
        XmlRole { name: "MISC_AMOUNT"; query: "string-join(RECIPE/MISCS/MISC/DISPLAY_AMOUNT/string(), ';')" }
        XmlRole { name: "MISC_TIME"; query: "string-join(RECIPE/MISCS/MISC/DISPLAY_TIME/string(), ';')" }

        // Yeast
        XmlRole { name: "YEAST_NAME"; query: "string-join(RECIPE/YEASTS/YEAST/NAME/string(), ';')" }
        XmlRole { name: "YEAST_LAB"; query: "string-join(RECIPE/YEASTS/YEAST/LABORATORY/string(), ';')" }
        XmlRole { name: "YEAST_PRODUCT"; query: "string-join(RECIPE/YEASTS/YEAST/PRODUCT_ID/string(), ';')" }

        // Mash Steps
        XmlRole { name: "MASH_STEP"; query: "string-join(RECIPE/MASH/MASH_STEPS/MASH_STEP/NAME/string(), ';')" }
        XmlRole { name: "MASH_AMOUNT"; query: "string-join(RECIPE/MASH/MASH_STEPS/MASH_STEP/DISPLAY_INFUSE_AMT/string(), ';')" }
        XmlRole { name: "MASH_INFUSE"; query: "string-join(RECIPE/MASH/MASH_STEPS/MASH_STEP/INFUSE_TEMP/string(), ';')" }
        XmlRole { name: "MASH_TEMP"; query: "string-join(RECIPE/MASH/MASH_STEPS/MASH_STEP/DISPLAY_STEP_TEMP/string(), ';')" }

        onStatusChanged: {

            if (status == XmlListModel.Ready) {
                recipeName = xmlModel.get(0).NAME;
                recipeType = xmlModel.get(0).TYPE;
                recipeStyle = xmlModel.get(0).STYLE;
                recipeCategory = xmlModel.get(0).CATEGORY;
                recipeCategoryNumber = xmlModel.get(0).CATEGORY_NUMBER;
                recipeCategoryLetter = xmlModel.get(0).STYLE_LETTER;
                recipeCategoryCombined = recipeCategoryNumber.concat(recipeCategoryLetter);
                recipeBatchSize = xmlModel.get(0).BATCH_VOLUME;
                recipeBoilSize = xmlModel.get(0).BOIL_VOLUME;

                let t_recipeOG = xmlModel.get(0).BATCH_OG;
                recipeOG = parseFloat(t_recipeOG);

                let t_recipeFG = xmlModel.get(0).BATCH_FG;
                recipeFG = parseFloat(t_recipeFG);

                let t_recipeABV = xmlModel.get(0).ABV;
                recipeABV = parseFloat(t_recipeABV);

                let t_recipeIBU = xmlModel.get(0).IBU;
                recipeIBU = parseFloat(t_recipeIBU);

                let t_recipeColor = xmlModel.get(0).COLOR;
                recipeColor = parseFloat(t_recipeColor);

                fermentableNames = xmlModel.get(0).FERMENTABLE_NAME;
                fermentableAmounts = xmlModel.get(0).FERMENTABLE_AMOUNT;
                fermentableTypes = xmlModel.get(0).FERMENTABLE_TYPE;

                fermentables = combineStrings(fermentableNames, fermentableAmounts, fermentableTypes);
                fermentableModel.clear();

                for (let i = 0; i < fermentables[0].length; i++) {
                    fermentableModel.append({name: fermentables[0][i], type: fermentables[2][i], amount: fermentables[1][i]});
                    fermentableModel.setProperty(i, "color", "blue");
                }

                hopNames = xmlModel.get(0).HOP_NAME;
                hopAmounts = xmlModel.get(0).HOP_AMOUNT;
                hopUses = xmlModel.get(0).HOP_USE;
                hopTimes = xmlModel.get(0).HOP_TIME;
                hopForms = xmlModel.get(0).HOP_FORM;

                hops = combineStrings(hopNames, hopAmounts, hopUses, hopTimes,hopForms)
                hopModel.clear();

                for (var e = 0; e < hops[0].length; e++) {
                    hopModel.append({name: hops[0][e], amount: hops[1][e], use: hops[2][e], time: hops[3][e], form: hops[4][e]});
                }

                yeastNames = xmlModel.get(0).YEAST_NAME;
                yeastLabs = xmlModel.get(0).YEAST_LAB;
                yeastProducts = xmlModel.get(0).YEAST_PRODUCT;

                yeasts = combineStrings(yeastNames, yeastLabs, yeastProducts);
                yeastModel.clear();

                for (var d = 0; d < yeasts[0].length; d++) {
                    yeastModel.append({name: yeasts[0][d], lab: yeasts[1][d], product: yeasts[2][d]});
                }

                mashSteps = xmlModel.get(0).MASH_STEP;
                mashAmounts = xmlModel.get(0).MASH_AMOUNT;
                mashInfuse = xmlModel.get(0).MASH_INFUSE;
                mashTemps = xmlModel.get(0).MASH_TEMP;

                mash = [];
                mash = combineStrings(mashSteps, mashAmounts, mashInfuse, mashTemps);
                mashModel.clear();

                for (var f = 0; f < mash[0].length; f++) {
                    if (mash[1][f].includes("qt")) {
                        let t_mashAmount = parseFloat(mash[1][f]);
                        t_mashAmount = t_mashAmount / 4;
                        t_mashAmount += " gal";
                        mashModel.append({step: mash[0][f], amount: t_mashAmount, infuse: mash[2][f], temp: mash[3][f]});
                    } else {
                        mashModel.append({step: mash[0][f], amount: mash[1][f], infuse: mash[2][f], temp: mash[3][f]});
                    }
                }

                let spargeAmount = parseFloat(recipeBoilSize) - (parseFloat(mash[1][0]) / 4);
                spargeAmount = Math.round(spargeAmount * 100) / 100
                mashModel.append({step: "Sparge", amount: String(spargeAmount) + " gal", infuse: "", temp: ""});

                graphABV.update();
                graphFg.update();
                graphIbu.update();
                graphOg.update();
                graphSrm.update();

                readBjcpStyleGuidelines();
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#FAFAFA"
    }

    Rectangle {
        id: titleBar
        width: parent.width
        height: 50

        Text {
            text: recipeName + ' - ' + recipeABV + "%"
            color: "#000000"
            font.bold: true
            font.pixelSize: 24
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    DropShadow {
        anchors.fill: titleBar
        horizontalOffset: 0
        verticalOffset: 3
        radius: 8.0
        samples: 17
        color: "#80000000"
        source: titleBar
    }

    Image {
        id: beerColor
        source: "images/BeerGlass.png"
        sourceSize: Qt.size(75, 125)
        width: 75
        height: 125
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: titleBar.height + 8 + 20
        smooth: true
        visible: false
    }

    ColorOverlay {
        anchors.fill: beerColor
        source: beerColor
        color: convertSRM(recipeColor)
    }

    Rectangle {
        id: batchInfoLeft
        anchors.left: beerColor.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: titleBar.height + 8 + 20
        width: 250

        Text {
            id: nameInfo1
            text: "Name"
            color: "black"
            font.pixelSize: 16
        }

        Text {
            id: nameInfo2
            text: recipeName
            color: "black"
            anchors.top: nameInfo1.bottom
            anchors.topMargin: 5
            font.bold: true
            font.pixelSize: 18
        }

        Rectangle {
            id: separatorLIne
            height: 2
            width: parent.width
            color: "black"
            anchors.top: nameInfo2.bottom
            anchors.topMargin: 15
        }

        Text {
            id: nameInfo3
            text: "Type"
            color: "black"
            anchors.top: separatorLIne.bottom
            anchors.topMargin: 15
            font.pixelSize: 16
        }

        Text {
            id: nameInfo4
            text: recipeType
            color: "black"
            anchors.top: nameInfo3.bottom
            anchors.topMargin: 5
            font.bold: true
            font.pixelSize: 18
        }
    }

    Rectangle {
        id: batchInfoRight
        anchors.left: batchInfoLeft.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: titleBar.height + 8 + 20
        width: 500
        height: 250
        color: "#FAFAFA"

        ListView {
            id: fermentableLilstView
            model: xmlModel
            interactive: false
            orientation: Qt.Vertical
            delegate: Column {
                spacing: 2
                Text { text: "<b>Style:</b> " + STYLE; font.pixelSize: 16 }
                Text { text: "<b>Category:</b> " + CATEGORY; font.pixelSize: 16 }
                Text { text: "<b>Batch Size:</b> " + BATCH_VOLUME; font.pixelSize: 16 }
                Text { text: "<b>Boil Size:</b> " + BOIL_VOLUME; font.pixelSize: 16 }
                Text { text: "<b>Boil Time:</b> " + parseInt(BOIL_TIME) + " minutes"; font.pixelSize: 16 }
                Text { text: "<b>Efficiency:</b> " + parseInt(EFFICIENCY) + "%"; font.pixelSize: 16 }
            }
        }
    }

    BrewingGraph {
        id: graphABV
        anchors.top: parent.top
        anchors.topMargin: titleBar.height + 8 + 20
        anchors.right: parent.right
        anchors.rightMargin: 10
        width: 240
        height: 20
        value: recipeABV
        graphMin: 0
        graphMax: 100
    }

    Text {
        anchors.right: graphABV.left
        anchors.rightMargin: 5
        anchors.verticalCenter: graphABV.verticalCenter
        text: "ABV"
        color: "#000000"
    }

    BrewingGraph {
        id: graphOg
        anchors.top: graphABV.bottom
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 10
        width: 240
        height: 20
        value: recipeOG
        graphMin: 0
        graphMax: 2
    }

    Text {
        anchors.right: graphOg.left
        anchors.rightMargin: 5
        anchors.verticalCenter: graphOg.verticalCenter
        text: "OG"
        color: "#000000"
    }

    BrewingGraph {
        id: graphFg
        anchors.top: graphOg.bottom
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 10
        width: 240
        height: 20
        value: recipeFG
        graphMin: 0
        graphMax: 2

    }

    Text {
        anchors.right: graphFg.left
        anchors.rightMargin: 5
        anchors.verticalCenter: graphFg.verticalCenter
        text: "FG"
        color: "#000000"
    }

    BrewingGraph {
        id: graphIbu
        anchors.top: graphFg.bottom
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 10
        width: 240
        height: 20
        value: recipeIBU
        graphMin: 0
        graphMax: 100
    }

    Text {
        anchors.right: graphIbu.left
        anchors.rightMargin: 5
        anchors.verticalCenter: graphIbu.verticalCenter
        text: "IBU"
        color: "#000000"
    }

    BrewingGraph {
        id: graphSrm
        anchors.top: graphIbu.bottom
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 10
        width: 240
        height: 20
        value: recipeColor
        graphMin: 0
        graphMax: 42
    }

    Text {
        anchors.right: graphSrm.left
        anchors.rightMargin: 5
        anchors.verticalCenter: graphSrm.verticalCenter
        text: "SRM"
        color: "#000000"
    }

    Rectangle {
        height: 2
        anchors.top: beerColor.bottom
        anchors.topMargin: 2
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 15
        color: "black"
    }

    Image {
        id: grainsIcon
        source: "images/Grains.png"
        sourceSize: Qt.size(38, 56)
        anchors.top: beerColor.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 20
        smooth: true
        visible: true
    }

    Rectangle {
        id: fermentableBackground
        anchors.left: grainsIcon.right
        anchors.leftMargin: 10
        anchors.top: grainsIcon.top
        height: fermentableList.contentHeight + 25
        width: 470 + 10
        color: "#FAFAFA"

        Rectangle {
            id: fermentableTitle
            width: parent.width
            height: 25
            color: "lightgrey"

            RowLayout {
                spacing: 5
                layoutDirection: Qt.LeftToRight
                Layout.alignment: Qt.AlignVCenter
                height: 25

                Text {
                    Layout.preferredWidth: 225
                    text: "Name"
                }
                Text {
                    Layout.preferredWidth: 120
                    text: "Type"
                }
                Text {
                    Layout.preferredWidth: 125
                    text: "Amount"
                }
            }
        }

        ListView {
            id: fermentableList
            model: fermentableModel
            orientation: Qt.Vertical
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.left: parent.left
            height: parent.height
            currentIndex: -1

            highlight: Rectangle {
                color: fermentableList.isCurrentItem ? "black" : "red"
                opacity: 0.7
                focus: true
                Behavior on y {
                    SpringAnimation {
                        spring: 3
                        damping: 0.2
                    }
                }
            }

            delegate: RowLayout {
                id: fermentableLayout
                spacing: 5
                layoutDirection: Qt.LeftToRight


                MouseArea {
                      id: mouse_area1
                      hoverEnabled: true
                      width: parent.width
                      height: parent.height
                      onClicked: {
                          if (fermentableList.currentIndex === index) {
                              fermentableList.currentIndex = -1
                          }
                          else {
                              fermentableList.currentIndex = index
                          }
                      }

                  }


                Text {
                    Layout.preferredWidth: 225
                    text: name
                    color: fermentableLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: fermentableLayout.ListView.isCurrentItem ? true: false
                }
                Text {
                    Layout.preferredWidth: 120
                    text: type
                    color: fermentableLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: fermentableLayout.ListView.isCurrentItem ? true: false
                }
                Text {
                    Layout.preferredWidth: 125
                    text: amount
                    color: fermentableLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: fermentableLayout.ListView.isCurrentItem ? true: false
                }
            }

            ListModel {
                id: fermentableModel
            }
        }
    }

    Image {
        id: hopsIcon
        source: "images/Hops.png"
        sourceSize: Qt.size(38, 56)
        anchors.top: fermentableBackground.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 20
        smooth: true
        visible: true
    }

    Rectangle {
        id: hopsBackground
        anchors.left: hopsIcon.right
        anchors.leftMargin: 10
        anchors.top: hopsIcon.top
        height: hopList.contentHeight + 25
        width: 460 + 20
        color: "#FAFAFA"

        Rectangle {
            width: parent.width
            height: 25
            color: "lightgrey"

            RowLayout {
                spacing: 5
                layoutDirection: Qt.LeftToRight
                Layout.alignment: Qt.AlignVCenter
                height: 25

                Text {
                    Layout.preferredWidth: 150
                    text: "Name"
                }
                Text {
                    Layout.preferredWidth: 75
                    text: "Amount"
                }
                Text {
                    Layout.preferredWidth: 75
                    text: "Use"
                }
                Text {
                    Layout.preferredWidth: 80
                    text: "Time"
                }
                Text {
                    Layout.preferredWidth: 80
                    text: "Form"
                }
            }
        }

        ListView {
            id: hopList
            model: hopModel
            interactive: false
            orientation: Qt.Vertical
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.left: parent.left
            height: parent.height
            currentIndex: -1

            highlight: Rectangle {
                color: hopList.isCurrentItem ? "black" : "red"
                opacity: 0.7
                focus: true
                Behavior on y {
                    SpringAnimation {
                        spring: 3
                        damping: 0.2
                    }
                }
            }

            delegate: RowLayout {
                id: hopsLayout
                spacing: 5
                layoutDirection: Qt.LeftToRight

                MouseArea {
                      id: mouse_area2
                      hoverEnabled: true
                      width: parent.width
                      height: parent.height
                      onClicked: {
                          if (hopList.currentIndex === index) {
                              hopList.currentIndex = -1
                          }
                          else {
                              hopList.currentIndex = index
                          }
                      }

                  }

                Text {
                    Layout.preferredWidth: 150
                    text: name
                    color: hopsLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: hopsLayout.ListView.isCurrentItem ? true: false
                }
                Text {
                    Layout.preferredWidth: 75
                    text: amount
                    color: hopsLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: hopsLayout.ListView.isCurrentItem ? true: false
                }
                Text {
                    Layout.preferredWidth: 75
                    text: use
                    color: hopsLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: hopsLayout.ListView.isCurrentItem ? true: false
                }
                Text {
                    Layout.preferredWidth: 80
                    text: time
                    color: hopsLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: hopsLayout.ListView.isCurrentItem ? true: false
                }
                Text {
                    Layout.preferredWidth: 80
                    text: form
                    color: hopsLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: hopsLayout.ListView.isCurrentItem ? true: false
                }
            }

            ListModel {
                id: hopModel
            }
        }
    }

    Image {
        id: yeastIcon
        source: "images/Yeast.png"
        sourceSize: Qt.size(38, 56)
        anchors.top: hopsBackground.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 20
        smooth: true
        visible: true
    }

    Rectangle {
        id: yeastsBackground
        anchors.left: yeastIcon.right
        anchors.leftMargin: 10
        anchors.top: yeastIcon.top
        height: yeastList.contentHeight + 25
        width: 470 + 10
        color: "#FAFAFA"


        Rectangle {
            width: parent.width
            height: 25
            color: "lightgrey"

            RowLayout {
                spacing: 5
                layoutDirection: Qt.LeftToRight
                Layout.alignment: Qt.AlignVCenter
                height: 25
                Text {
                    Layout.preferredWidth: 150
                    text: "Name"
                }
                Text {
                    Layout.preferredWidth: 195
                    text: "Lab"
                }
                Text {
                    Layout.preferredWidth: 125
                    text: "Product"
                }
            }
        }

        ListView {
            id: yeastList
            model: yeastModel
            interactive: false
            orientation: Qt.Vertical
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.left: parent.left
            currentIndex: -1

            highlight: Rectangle {
                color: yeastList.isCurrentItem ? "black" : "red"
                opacity: 0.7
                focus: true
                Behavior on y {
                    SpringAnimation {
                        spring: 3
                        damping: 0.2
                    }
                }
            }

            height: parent.height
            delegate: RowLayout {
                id: yeastLayout
                spacing: 5
                layoutDirection: Qt.LeftToRight

                MouseArea {
                      id: mouse_area3
                      hoverEnabled: true
                      width: parent.width
                      height: parent.height
                      onClicked: {
                          if (yeastList.currentIndex === index) {
                              yeastList.currentIndex = -1
                          }
                          else {
                              yeastList.currentIndex = index
                          }
                      }

                  }

                Text {
                    Layout.preferredWidth: 150
                    text: name
                    color: yeastLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: yeastLayout.ListView.isCurrentItem ? true: false
                }
                Text {
                    Layout.preferredWidth: 195
                    text: lab
                    color: yeastLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: yeastLayout.ListView.isCurrentItem ? true: false
                }
                Text {
                    Layout.preferredWidth: 125
                    text: product
                    color: yeastLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: yeastLayout.ListView.isCurrentItem ? true: false
                }

            }

            ListModel {
                id: yeastModel
            }
        }
    }

    Image {
        id: mashIcon
        source: "images/BeerGlass.png"
        sourceSize: Qt.size(38, 56)
        anchors.top: mashBackground.top
        anchors.right: mashBackground.left
        anchors.rightMargin: 10
        smooth: true
        visible: true
    }

    Rectangle {
        id: mashBackground
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: grainsIcon.top
        height: mashList.contentHeight + 25
        width: 405 + 15
        color: "#FAFAFA"

        Rectangle {
            width: parent.width
            height: 25
            color: "lightgrey"

            RowLayout {
                spacing: 5
                layoutDirection: Qt.LeftToRight
                Layout.alignment: Qt.AlignVCenter
                height: 25

                Text {
                    Layout.preferredWidth: 100
                    text: "Step"
                }
                Text {
                    Layout.preferredWidth: 100
                    text: "Amount"
                }
                Text {
                    Layout.preferredWidth: 100
                    text: "Infuse Temp"
                }
                Text {
                    Layout.preferredWidth: 105
                    text: "Hold Temp"
                }
            }
        }

        ListView {
            id: mashList
            model: mashModel
            interactive: false
            orientation: Qt.Vertical
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.left: parent.left
            currentIndex: -1

            highlight: Rectangle {
                color: mashList.isCurrentItem ? "black" : "red"
                opacity: 0.7
                focus: true
                Behavior on y {
                    SpringAnimation {
                        spring: 3
                        damping: 0.2
                    }
                }
            }

            height: parent.height
            delegate: RowLayout {
                id: mashLayout
                spacing: 5
                layoutDirection: Qt.LeftToRight

                MouseArea {
                      id: mouse_area34
                      hoverEnabled: true
                      width: parent.width
                      height: parent.height
                      onClicked: {
                          if (mashList.currentIndex === index) {
                              mashList.currentIndex = -1
                          }
                          else {
                              mashList.currentIndex = index
                          }
                      }

                  }

                Text {
                    Layout.preferredWidth: 100
                    text: step
                    color: mashLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: mashLayout.ListView.isCurrentItem ? true: false
                }
                Text {
                    Layout.preferredWidth: 100
                    text: amount
                    color: mashLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: mashLayout.ListView.isCurrentItem ? true: false
                }
                Text {
                    Layout.preferredWidth: 100
                    text: infuse
                    color: mashLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: mashLayout.ListView.isCurrentItem ? true: false
                }
                Text {
                    Layout.preferredWidth: 105
                    text: temp
                    color: mashLayout.ListView.isCurrentItem ? "white" : "black"
                    font.bold: mashLayout.ListView.isCurrentItem ? true: false
                }

            }

            ListModel {
                id: mashModel
            }
        }
    }

    Label {
        id: label_breweryTimer
        anchors {
            bottom: parent.bottom
            bottomMargin: 10
            horizontalCenter: parent.horizontalCenter
        }

        text: CountdownTimer.running ? secondsToTime(CountdownTimer.elapsed) : secondsToTime(CountdownTimer.startTime)
        color: "#000000"
        font.pointSize: 25
    }

    Label {
        id: commentsLabel
        text: qsTr("<b>Comments</b>")
        color: "#000000"
        anchors.top: mashBackground.bottom
        anchors.topMargin: 10
        anchors.left: mashBackground.left
    }

    Text {
        id: styleText
        anchors.top: commentsLabel.bottom
        anchors.topMargin: 2
        anchors.left: mashBackground.left
        width: mashBackground.width
        text: bjcpComments
        wrapMode: Text.WordWrap
    }

    Rectangle {
        id: overlayBackground
        height: parent.height
        width: parent.width
        color: "grey"
        visible: true
    }

    ListView {
        id: folderList
        y: 30
        width: parent.width
        height: parent.height - 60
        clip: true
        highlight: highlight
        highlightFollowsCurrentItem: true
        focus: true
        currentIndex: -1
        visible: true

        model: FolderListModel {
            id: folderListModel
            showDirsFirst: false
            folder: folderPath
            nameFilters: ["*.xml"]
        }

        delegate: Button {
            id: folderDelegate
            width: parent.width
            height: 50
            text: fileName
            font.bold: true
            highlighted: ListView.isCurrentItem

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    folderList.currentIndex = index;
                    recipeFile = (folderPath + "/" + fileName);
                }
            }

            background: Rectangle {
                color: highlighted ? "orange" : "gray"
                border.color: "black"
            }
        }
    }

    ToggleButton {
        id: button_openRecipe
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        backgroundColor: "#FAFAFA"
        borderColor: active ? "transparent" : "black"
        textColor: "black"
        width: 200
        height: 75
        text: qsTr("<b>Open Recipe</b>")
        visible: true
        onChecked: {
            if (active) {
                overlayBackground.visible = false;
                folderList.visible = false;
                xmlModel.source = recipeFile;
                textColor = "transparent";
                backgroundColor = "transparent";
            }
            else {
                overlayBackground.visible = true;
                folderList.visible = true;
                backgroundColor = "#FAFAFA";
                textColor = "black";
            }
        }
    }
}
