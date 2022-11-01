package websearch;

// parsuje MediaTimePoint, MediaDuration
public class MediaTime {
    // time: 03m32.120s
    String mt; // string ^
    int fps = 25;    // framu/sekundu
    long mtf;  // prepocteno na framy

    public MediaTime(String p) {
        setMediaTime(p);
    }

    public void setMediaTime(String p) {
        // nastav mtp
        this.mt = p;

        int m = mt.toUpperCase().indexOf("M");
        int s = mt.toUpperCase().indexOf("S");

        // nastav mtf
        if(fps > 9999) {  // volaky americky srac
            /*
             * The sampling rate of NTSC of 29.97(002997)...Hz: "PT1001N30000F"
             * (ISO/IEC JTC 1/SC 29/WG 11/N3966, page 96)
             */
            mtf = 0;
            System.err.println("The sampling rate of NTSC of 29.97(002997) unimplemented.");
        }
         else {  // at zije izi metricky system!
            this.mtf = 60*fps*Integer.parseInt(mt.substring(0, m));  // m

            float sf = Float.parseFloat(mt.substring(m+1, s))*fps;
            this.mtf += Math.round(sf);
         }
    }


    public String getMediaTimePoint() {
        return mt;
    }

    /**
     * N/A!
     * @param mtpf
     */
    public void setFrames(long mtf) {
        this.mtf = mtf;
    }

    public long getFrames() {
        return mtf;
    }

    /**
     * N/A!
     * @param fps
     */
    public void setFps(int fps) {
        this.fps = fps;
    }

    public int getFps() {
        return fps;
    }
}