

// const ExpressionNode = Expression

var ErrorList = new Array()
var TableList =  new Array()

var EditorTextArea = document.getElementById('editor')

var editor = CodeMirror.fromTextArea(EditorTextArea,{
    mode : "javascript",
    theme : "dracula",
    lineNumbers : true,
    autoCloseBrackets : true,
    gutters: ["CodeMirror-linenumbers", "breakpoints"]
})

editor.setSize(530, 600)

editor.on("gutterClick", function(cm, n) {
    var info = cm.lineInfo(n);
    console.log(info)
    cm.setGutterMarker(n, "breakpoints", info.gutterMarkers ? null : makeMarker());
});

function makeMarker() {
    var marker = document.createElement("div");
    marker.style.color = "#822";
    marker.innerHTML = "●";
    return marker;
}

var consoleTextArea = document.getElementById('console')

var webTsConsole = CodeMirror.fromTextArea(consoleTextArea, {
    mode: "javascript",
    theme: "dracula",
    lineNumbers: true
});

webTsConsole.setSize(530, 600)


// CompileCode()
function CompileCode () {

    let compile = TsGrammar.parse(editor.getValue())
    // console.log(compile)
    try {
        let threeACode = compile.exec()
        console.log(threeACode)
        webTsConsole.setValue(threeACode)

    }catch (e) {
       webTsConsole.setValue(webTsConsole.getValue() + e.toString())
        console.log(e)
    }


    // console.log('ErrorList:')
    // console.log(ErrorList)
    alert('Funciona!!')



    // let table = new Tabulator("#example-table", {
    //     data:ErrorList, //assign data to table
    //     autoColumns:true, //create columns from data field names
    // });
    //
    // let table2 = new Tabulator("#example-table2", {
    //     data:TableList, //assign data to table
    //     autoColumns:true, //create columns from data field names
    // });
}


var $ = go.GraphObject.make;

var myDiagram =
    $(go.Diagram, "myDiagramDiv",
        {
            "undoManager.isEnabled": true,
            layout: $(go.TreeLayout,
                { angle: 90, layerSpacing: 35 })
        });

myDiagram.nodeTemplate =
    $(go.Node, "Vertical",
        { selectionObjectName: "BODY" },
        $(go.Panel, "Auto", { name: "BODY" },
            $(go.Shape, "RoundedRectangle",
                new go.Binding("fill"),
                new go.Binding("stroke")),
            $(go.TextBlock,
                { font: "bold 12pt Arial, sans-serif", margin: new go.Margin(4, 2, 2, 2) },
                new go.Binding("text"))
        ),
        $(go.Panel,  // this is underneath the "BODY"
            { height: 17 },  // always this height, even if the TreeExpanderButton is not visible
            $("TreeExpanderButton")
        )
    );

myDiagram.linkTemplate =
    $(go.Link,
        $(go.Shape, { strokeWidth: 1.5 }));

// define a Link template that routes orthogonally, with no arrowhead
myDiagram.linkTemplate =
    $(go.Link,
        { routing: go.Link.Orthogonal, corner: 5 },
        $(go.Shape, // the link's path shape
            { strokeWidth: 3, stroke: "#555" }));


graphCode = function () {

    let translation = TsTranslatorGrammar.parse(editor.getValue())

    console.log(translation)
    myDiagram.model =
        $(go.TreeModel,
            { nodeDataArray: translation});
}



