import React, { useState } from 'react';
import Form from './components/Form';
import ImageDisplay from './components/ImageDisplay';
import TextDisplay from './components/TextDisplay';

const App: React.FC = () => {
  const [image, setImage] = useState<string | null>(null);
  const [text, setText] = useState<string | null>(null);

  const handleDataReceive = (receivedImage: string, receivedText: string) => {
    setImage(receivedImage);
    setText(receivedText);
  };

  return (
    <div style={appStyle}>
      <h1 style={headerStyle}>ML Pipeline Interface</h1>
      <Form onDataReceive={handleDataReceive} />
      {image && <ImageDisplay image={image} />}
      {text && <TextDisplay text={text} />}
    </div>
  );
};

const appStyle: React.CSSProperties = {
  fontFamily: 'Arial, sans-serif',
  padding: '2rem',
  maxWidth: '800px',
  margin: '0 auto',
};

const headerStyle: React.CSSProperties = {
  textAlign: 'center',
  color: '#333',
};

export default App;
