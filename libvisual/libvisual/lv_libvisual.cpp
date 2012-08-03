/* Libvisual - The audio visualisation framework.
 * 
 * Copyright (C) 2004, 2005, 2006 Dennis Smit <ds@nerds-incorporated.org>
 *
 * Authors: Dennis Smit <ds@nerds-incorporated.org>
 *
 * $Id: lv_libvisual.c,v 1.39 2006/01/22 13:23:37 synap Exp $
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

#include "config.h"
#include "version.h"

#include "lv_libvisual.h"
#include "lv_common.h"

#include "lv_alpha_blend.h"
#include "lv_fourier.h"
#include "lv_plugin_registry.h"
#include "lv_log.h"
#include "lv_param.h"
#include "lv_util.h"

#include "gettext.h"

extern "C" {

  // Set a progname from argv[0] when we're capable of doing so.
  char *__lv_progname = 0;

  void visual_alpha_blend_initialize (void);
  void visual_cpu_initialize (void);
  void visual_mem_initialize (void);
}

namespace LV
{

  namespace {

    int init_params (VisParamList *params)
    {
        visual_return_val_if_fail (params != NULL, -1);

        // Song information parameters
        visual_param_list_add_many (params,
            visual_param_new_int ("songinfo-show",
                                  NULL,
                                  1),
            visual_param_new_int ("songinfo-timeout",
                                  "Songinfo timeout in seconds",
                                  5),
            visual_param_new_int ("songinfo-in-plugins",
                                  "Show songinfo in plugins",
                                  TRUE),
            visual_param_new_int ("songinfo-cover-width",
                                  "Song cover art width",
                                  128),
            visual_param_new_int ("songinfo-cover-height",
                                  "Song cover art height",
                                  128),
            NULL);

        return 0;
    }

  } // anonymous namespace

  class System::Impl
  {
  public:

      VisParamList *params;

      Impl ()
          : params (0)
      {}
  };

  template <>
  LV_API System* Singleton<System>::m_instance = 0;

  void System::init (int& argc, char**& argv)
  {
      if (!m_instance)
          m_instance = new System (argc, argv);
  }

  std::string System::get_version () const
  {
      return VISUAL_VERSION " (" LV_REVISION ")";
  }

  int System::get_api_version () const
  {
      return VISUAL_API_VERSION;
  }

  VisParamList *System::get_params () const
  {
      return m_impl->params;
  }

  System::System (int& argc, char**& argv)
      : m_impl(new Impl)
  {
      visual_log (VISUAL_LOG_INFO, "Starting Libvisual %s", get_version ().c_str ());

#if ENABLE_NLS
      bindtextdomain (GETTEXT_PACKAGE, LOCALE_DIR);
      bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
#endif

      __lv_progname = visual_strdup (argv[0]);

      /* Initialize CPU caps */
      visual_cpu_initialize ();

      /* Initialize Mem system */
      visual_mem_initialize ();

      /* Initialize CPU-accelerated graphics functions */
      visual_alpha_blend_initialize ();

      /* Initialize high-resolution timer system */
	  Time::init ();

      /* Initialize FFT system */
      Fourier::init ();

      /* Initialize the plugin registry */
      PluginRegistry::init ();

      m_impl->params = visual_param_list_new ();
      init_params (m_impl->params);
  }

  System::~System ()
  {
      PluginRegistry::deinit ();
	  Fourier::deinit();

      visual_object_unref (VISUAL_OBJECT (m_impl->params));
  }

} // LV namespace
