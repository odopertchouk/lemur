"""
.. module: lemur.sources.models
    :platform: unix
    :copyright: (c) 2015 by Netflix Inc., see AUTHORS for more
    :license: Apache, see LICENSE for more details.
.. moduleauthor:: Kevin Glisson <kglisson@netflix.com>
"""
import copy
from sqlalchemy import Column, Integer, String, Text
from sqlalchemy_utils import JSONType
from lemur.database import db

from lemur.plugins.base import plugins


class Source(db.Model):
    __tablename__ = 'sources'
    id = Column(Integer, primary_key=True)
    label = Column(String(32))
    options = Column(JSONType)
    description = Column(Text())
    plugin_name = Column(String(32))

    @property
    def plugin(self):
        p = plugins.get(self.plugin_name)
        c = copy.deepcopy(p)
        c.options = self.options
        return c
