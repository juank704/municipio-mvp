/** @odoo-module **/
import { registry } from "@web/core/registry";
import { browser } from "@web/core/browser/browser";
import { _t } from "@web/core/l10n/translation";
const userMenuRegistry = registry.category("user_menuitems");
   function debugItem(env) {
       const urlParams = new URLSearchParams(window.location.search);
       urlParams.set('debug', '1');
       const debugURL = window.location.pathname + '?' + 
                        urlParams.toString();
       return {
           type: "item",
           id: "debug",
           description: _t("Activate the developer mode"),
           href: debugURL,
           callback: () => {
               browser.open(debugURL, "_self");
           },
           sequence: 50,
       };
   }
   registry.category("user_menuitems").add("debug", debugItem)