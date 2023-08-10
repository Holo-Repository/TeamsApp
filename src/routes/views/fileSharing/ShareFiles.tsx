import { useRef, useState } from "react";
import { Button, Input, Field } from '@fluentui/react-components';
import { ArrowUpload16Regular as Upload } from "@fluentui/react-icons";

import DropZone from "./DropZone";
import "../../../styles/DropZone.css";
import { AcceptedFileTypes } from "./AcceptedFileTypes";


/**
 * The shareFiles functional component renders a div with a form to input URLs and a DropZone to input files.
 *  It records the input Files and URLs as arrays and dispatches them to the FileLoader component.
 */
function ShareFiles(props: { fileType: AcceptedFileTypes, loadFile: (fileURL: string) => Promise<void> }) {
    const inputRef = useRef<HTMLInputElement>(null);
    const [fileURL, setFileURL] = useState("");
    const [isValidURL, setIsValidURL] = useState(false);

    const loadFileURL = async () => {
        if (!inputRef.current) throw new Error("Input ref not set");
        if (!isValidURL) throw new Error("Invalid URL");
        props.loadFile(fileURL);
    }

    const validateURL = (url: string) => {
        const regex = /^(ftp|http|https):\/\/[^ "]+$/;
        return regex.test(url);
    }

    return (
        <div>
            {/* <DropZone handleFile={setfile} /> */}
            <Field
                label="File URL"
                validationState={isValidURL ? 'success' : 'error'}
                validationMessageIcon={isValidURL ? 'success' : 'error'}
            >
                <div>
                    <Input 
                        placeholder="Enter a file URL"
                        ref={inputRef}
                        onChange={(e) => {
                            const url = e.target.value;
                            setFileURL(url);
                            setIsValidURL(validateURL(url));
                        }}
                    />
                    <Button icon={<Upload />} appearance='primary' onClick={loadFileURL} disabled={!isValidURL} />
                </div>
            </Field>
        </div>
    );

}

export default ShareFiles;