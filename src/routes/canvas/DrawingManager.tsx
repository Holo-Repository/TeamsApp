import React from 'react';
import { InkingManager, InkingTool } from "@microsoft/live-share-canvas";

import Pen from "./tools/Pen";
import Eraser from './tools/Eraser';
import Highlighter from './tools/Highlighter';
import LaserPointer from './tools/LaserPointer';


class DrawingManager extends React.Component<{inkingManager: InkingManager}> {
    state = {
        selectedTool: InkingTool.pen,
        doubleClicked: false
    }

    constructor(props: {inkingManager: InkingManager}) {
        super(props);
        this.setTool = this.setTool.bind(this);
        this.ext = this.ext.bind(this);
    }

    setTool(tool: InkingTool) {
        this.props.inkingManager.tool = tool;
        
        let { selectedTool } = this.state;
        this.setState({ 
            selectedTool: tool, 
            doubleClicked: selectedTool === tool ? !this.state.doubleClicked : false
        });
    }

    ext(callback: (inkingManager: InkingManager) => void = () => {}) {
        callback(this.props.inkingManager);
        this.setState({ doubleClicked: false });
    }

    render(): React.ReactNode {
        console.log(this.state)

        const { selectedTool, doubleClicked } = this.state;
        let toolProps = {
            activeTool: selectedTool,
            isDoubleClick: doubleClicked,
            selectTool: this.setTool,
            ext: this.ext,
        }

        return (
            <div>
                <Pen {...toolProps} />
                <Highlighter {...toolProps} />
                <Eraser {...toolProps} />
                <LaserPointer {...toolProps} />
            </div>
        );
    }
}

export default DrawingManager;