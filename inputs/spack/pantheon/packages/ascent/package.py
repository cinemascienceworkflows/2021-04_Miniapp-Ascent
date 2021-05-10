# Copyright 2013-2021 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack import *
from spack.pkg.builtin.ascent import Ascent

class Ascent(Ascent):
    # version used by pantheon
    version('pantheon_ver', commit="b2f0bb4ac7c6deeea5a05839ea0df8d0d001aa8c", submodules=True)
