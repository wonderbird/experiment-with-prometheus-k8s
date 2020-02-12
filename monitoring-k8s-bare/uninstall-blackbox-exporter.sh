#!/bin/bash
helm delete blackbox-exporter
helm del --purge blackbox-exporter
