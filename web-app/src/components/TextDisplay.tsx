import React from 'react';

interface TextDisplayProps {
  text: string;
}

const TextDisplay: React.FC<TextDisplayProps> = ({ text }) => {
  return (
    <div style={containerStyle}>
      <p style={textStyle}>{text}</p>
    </div>
  );
};

const containerStyle: React.CSSProperties = {
  padding: '1rem',
  border: '1px solid #ccc',
  borderRadius: '4px',
  backgroundColor: '#f9f9f9',
};

const textStyle: React.CSSProperties = {
  margin: 0,
};

export default TextDisplay;
