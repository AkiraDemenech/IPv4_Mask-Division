package redes;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

public class Rede {
    
    public static final long MAX_VALUE = (long) Math.pow(2, 32) - 1;
    private long ip;
    private int mask;
    private int[] octetos;
    
    public static Rede[] ordenar (Rede[] r) {
        int m = 32;
        for(int c=0; c<r.length; c++) {
            if(r[c].mask>m) {
                m = c;
                Rede[] r2 = new Rede[r.length];
                for(c=0; c<r2.length; c++)
                    r2[c] = r[(c+m)%r.length];
                return r2;
            }
            m = r[c].mask;
        }
        return r;
    }
    
    public Rede () {
        ip = 0;
        mask = 24;
        octetos = getOctetos();
    }
    public Rede (int[] octetos, int mask) {
        this.octetos = new int[octetos.length];
        this.mask = mask;
        ip = 0;
        for(int c=0; c<octetos.length; c++) {
            this.octetos[c] = octetos[c];
            ip = (ip*256) + octetos[c];
        }
    }
    public Rede (long ip, int mask) {
        this.ip = ip;
        this.mask = mask;
        octetos = getOctetos();
    }
    
    public int[] getOctetos () {
        long o = ip;
        int[] oct = new int[4];
        for(int c=3; c>=0; c--) {
            oct[c] = (int) o%256;
            o /= 256;
            
            if(oct[c]<0)
                oct[c] += 256;
        }
        return oct;
    }
    
    public Rede clonar () {
        return new Rede(getOctetos(), mask);
    }
    
    public Rede[] subdividir (long d) {
        
        Rede[] r = {clonar()};
        
        while(r.length<d) {
            
            Rede[] redes = new Rede[r.length + 1];
            
            for(int c=1; c<r.length; c++)
                redes[c-1] = r[c];
            
            redes[redes.length - 1] = r[0].dividir();
            redes[redes.length - 2] = r[0];
            
            r = redes;
            
        }
        
        return ordenar(r);
    }
    public Rede dividir () {
        mask++;
        return new Rede ((long)(ip + Math.pow(2, 32 - mask)), mask);
    }
    
    public boolean ok () {
        return ((mask>=0 && mask<=32) && (ip>=0 && ip<=MAX_VALUE) && (ip + Math.pow(2, 32 - mask) <= MAX_VALUE + 1));
    }
    
    public int getMask () {
        return mask;
    }
    
    public String getIp () {
        StringBuffer s = new StringBuffer();
        
        for(int c=0; c<octetos.length; c++) {
            s.append(".");
            if(octetos[c]<100)
                s.append("0");
            if(octetos[c]<10)
                s.append("0");
            s.append(octetos[c]);
            if(octetos[c]<0 || octetos[c]>=256)
                s.append("e");
        }
        
        return s.substring(1).toString();
    }
    
    @Override
    public String toString() {
        
        StringBuffer s = new StringBuffer(getIp());
        
        if(octetos.length>4)
            s.append("-Err");
        
        return s.toString() + "/" + mask;
    }
        
    
}
