#!/usr/bin/python2

"""
A simple script to calculate a possibility problem.
"""

import os
import sys
from decimal import  *

def calculatefactorial(n):
    # calculate n!
    totaltimes = 1
    for i in range(1, n+1):
        totaltimes *= i
    return totaltimes

def calcultechance(m, n):
    # calculate C(m, n) = m!/(n!*(m-n)!)
    p_total = calculatefactorial(m)
    p_selected = calculatefactorial(n)
    p_totalremain = calculatefactorial(m-n)
    
    return p_total/(p_selected*p_totalremain)

def calselectedchancespergroup(numOfOthers, numOfSelectedOnes, totalChances):
    AllUnselectedChances = calcultechance(numOfOthers, numOfSelectedOnes)
    SelectedChancesPerTeam = (1-(Decimal(AllUnselectedChances))/(Decimal(totalChances)))
    return SelectedChancesPerTeam

def main(argv):
    """
    Inputs:
    1. how many candidates in total;
    2. how many lucky guys will be selected;
    3. how many guys in our team;
    4. how many telephones are there as receivers;
    """
    totalAll = int(argv[1])
    selectedAll = int(argv[2])
    numOfTeamMembers = int(argv[3])
    numOfGroups = int(argv[4])

    totalPerGroup = totalAll/numOfGroups
    selectedPerGroup = selectedAll/numOfGroups
    
    totalChances = calcultechance(totalPerGroup, selectedPerGroup)

    firstResult = calselectedchancespergroup((totalPerGroup-numOfTeamMembers), selectedPerGroup, totalChances)

    secondSelectedChancePerGroup = calselectedchancespergroup((totalPerGroup-numOfTeamMembers/numOfGroups), selectedPerGroup, totalChances)
    secondResult = (1-((1-Decimal(secondSelectedChancePerGroup))**3))

    print "option one result is %s%%." % str(firstResult*100)
    print "option two result is %s%%." % str(secondResult*100)
    
if __name__ == "__main__":
    main(sys.argv)
