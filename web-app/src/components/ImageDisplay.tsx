import React from 'react';

interface ImageDisplayProps {
  image: string;
}

const ImageDisplay: React.FC<ImageDisplayProps> = ({ image }) => {
  return (
    <div style={containerStyle}>
      <img src={image} alt="Received" style={imageStyle} />
    </div>
  );
};

const containerStyle: React.CSSProperties = {
  textAlign: 'center',
};

const imageStyle: React.CSSProperties = {
  maxWidth: '100%',
  height: 'auto',
};

export default ImageDisplay;
