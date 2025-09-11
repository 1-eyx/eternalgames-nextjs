// components/Hero.tsx
import React from 'react';

const Hero = () => (
    <section className="hero">
        <video className="hero-video" autoPlay muted loop playsInline>
            <source src="https://videos.pexels.com/video-files/4784234/4784234-hd_1920_1080_25fps.mp4" type="video/mp4" />
        </video>
        <div className="hero-overlay"></div>
        <div className="hero-content">
            <h1>EternalGames</h1>
            <p>Games Are Forever.</p>
            <button className="hero-button">Explore The Collection</button>
        </div>
    </section>
);

export default Hero;