/**
 *
 * License:
 * $(TABLE
 *   $(TR $(TD cairoD wrapper/bindings)
 *     $(TD $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)))
 *   $(TR $(TD $(LINK2 http://cgit.freedesktop.org/cairo/tree/COPYING, _cairo))
 *     $(TD $(LINK2 http://cgit.freedesktop.org/cairo/tree/COPYING-LGPL-2.1, LGPL 2.1) /
 *     $(LINK2 http://cgit.freedesktop.org/cairo/plain/COPYING-MPL-1.1, MPL 1.1)))
 * )
 * Authors:
 * $(TABLE
 *   $(TR $(TD Johannes Pfau) $(TD cairoD))
 *   $(TR $(TD $(LINK2 http://cairographics.org, _cairo team)) $(TD _cairo))
 * )
 */
/*
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module cairo.c.ps;

import cairo.c.cairo;

static if(CAIRO_HAS_PS_SURFACE)
{
    extern(C):

    /* PS-surface functions */
    /**
     * $(D cairo_ps_level_t) is used to describe the language level of the
     * PostScript Language Reference that a generated PostScript file will
     * conform to.
     */
    enum cairo_ps_level_t
    {
        ///The language level 2 of the PostScript specification.
        CAIRO_PS_LEVEL_2,
        ///The language level 3 of the PostScript specification.
        CAIRO_PS_LEVEL_3
    }
    ///
    cairo_surface_t* cairo_ps_surface_create (const (char*) filename,
                 double             width_in_points,
                 double             height_in_points);
    ///
    cairo_surface_t* cairo_ps_surface_create_for_stream (cairo_write_func_t write_func,
                        void*         closure,
                        double        width_in_points,
                        double        height_in_points);
    ///
    void cairo_ps_surface_restrict_to_level (cairo_surface_t* surface,
                                        cairo_ps_level_t    level);
    ///
    void cairo_ps_get_levels (immutable(cairo_ps_level_t*)*  levels,
                         int*    num_levels);
    ///
    immutable(char)* cairo_ps_level_to_string (cairo_ps_level_t level);
    ///
    void cairo_ps_surface_set_eps (cairo_surface_t*    surface,
                  cairo_bool_t           eps);
    ///
    cairo_bool_t cairo_ps_surface_get_eps (cairo_surface_t    *surface);
    ///
    void cairo_ps_surface_set_size (cairo_surface_t* surface,
                   double         width_in_points,
                   double         height_in_points);
    ///
    void cairo_ps_surface_dsc_comment (cairo_surface_t*  surface,
                      const(char*)    comment);
    ///
    void cairo_ps_surface_dsc_begin_setup (cairo_surface_t *surface);
    ///
    void cairo_ps_surface_dsc_begin_page_setup (cairo_surface_t *surface);
}
else
{
    //static assert(false, "CairoD was not compiled with support for the ps backend");
}
