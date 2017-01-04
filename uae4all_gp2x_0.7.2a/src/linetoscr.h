
static __inline__ int LNAME (int spix, int dpix, int stoppos)
{
	/* CASO DUAL */
	
    unsigned short * __restrict__ buf = ((unsigned short *)xlinebuffer);
	
    if (bpldualpf) {
	    // OCS/ECS Dual playfield 
	    int *lookup = bpldualpfpri ? dblpf_ind2 : dblpf_ind1;
		int n = (stoppos-dpix);
    
        //center fix mithrendal
        dpix = (dpix-VISIBLE_LEFT_BORDER)*2 + VISIBLE_LEFT_BORDER;
	    while (n--) {
			register unsigned short d = colors_for_drawing.acolors[lookup[pixdata.apixels[spix]]];
			buf[dpix++] = d;
            buf[dpix++] = d;
            spix ++;
	    }
		
    } else {
	
#ifdef HDOUBLE
#define COPY_TYPE 0
#else
#define COPY_TYPE 1
#endif
			
#if COPY_TYPE == 0
		
        
        
		// SGC: optimizations using the __restrict__ keyword
		long int * __restrict__ acolors = (long int *)&colors_for_drawing.acolors;
		uae_u8 * __restrict__ apixels = (uae_u8 *)&pixdata.apixels;
		int n = (stoppos-dpix);
        
        //center fix mithrendal
        dpix = (dpix-VISIBLE_LEFT_BORDER)*2 + VISIBLE_LEFT_BORDER;

        
		while (n--) {
            register unsigned short val = (acolors[apixels[spix]]);
			buf[dpix++] = val;
            buf[dpix++] = val;
            
            spix ++;
		}
 /* mithrendal I have found this in a newer core. maybe its performance is better and we should take this in future...
        int n = (stoppos-dpix);
        while (n--) {
            uae_u32 spix_val;
            
            spix_val = pixdata.apixels[spix++];
            *((uae_u32 *)&buf[dpix]) = colors_for_drawing.acolors[spix_val];
            dpix += 2;
        }
*/
		
#elif COPY_TYPE == 1
		long int* __restrict__ acolors = (long int *)&colors_for_drawing.acolors;
		uae_u32* __restrict__ lpixels = (uae_u32*)(uae_u8 *)&pixdata.apixels[spix];
#ifdef __arm__
		// load up 64 pixels into the data cache (we hope)
		asm volatile("pld [%0]" : : "r" (lpixels));
#endif
		int n = (stoppos-dpix);
		int m = n & 0x3;
		n >>= 2;

		while (n--) {
			register uae_u32 srcpx = *lpixels++;
			
			buf[dpix++] = acolors[srcpx & 0xFF];
			srcpx >>= 8;
			buf[dpix++] = acolors[srcpx & 0xFF];
			srcpx >>= 8;
#ifdef __arm__
			// load up 32 pixels into the data cache (we hope)
			asm volatile("pld [%0]" : : "r" (lpixels+7));
#endif
			buf[dpix++] = acolors[srcpx & 0xFF];
			srcpx >>= 8;
			buf[dpix++] = acolors[srcpx & 0xFF];
			srcpx >>= 8;
		}
		
		uae_u8 * __restrict__ apixels = (uae_u8 *)lpixels;
		while (m--) {
			buf[dpix++] = (acolors[*apixels++]);
		}
#endif
    }
    return spix;
}

#undef LNAME
#undef HDOUBLE
#undef SRC_INC
#undef COPY_TYPE
