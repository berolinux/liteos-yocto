#
# SPDX-License-Identifier: MIT
#

from subprocess import Popen, PIPE

from oeqa.runtime.case import OERuntimeTestCase
from oeqa.core.decorator.oetimeout import OETimeout
import re

class FreeRTOSTest(OERuntimeTestCase):

    @OETimeout(15)
    def test_freertos_periodic(self):
        # Send empty string which allows us to read the output of the RTOS serial console
        cmd = ''
        # Look for Periodic task which run every 10 seconds, so there
        # should be one printed on the serial console since the timeout is 15
        pattern = 'Periodic task 10 secs'
        # Send it raw, so it does not look for echo $?, it just looks at the output
        status, output = self.target.runner.run_serial(cmd,raw=True)
        match = bool(re.search(pattern,output))
        self.assertEqual(match, True)
