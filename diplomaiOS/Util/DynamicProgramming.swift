//
//  DynamicProgramming.swift
//  diplomaiOS
//
//  Created by Mary Gerina on 10/1/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

import Foundation

public class DinamicProgramming {
    List<FourerMatrix> fileMatrix;
    List<DistanceMatrix> distanceMatrixes;
    FourerMatrix currentMatrix;
    public List<double> distances;
    
    public DinamicProgramming(List<FourerMatrix> fileMatrix, double[,] currentMatrix)
{
    this.fileMatrix = fileMatrix;
    this.currentMatrix = new FourerMatrix(currentMatrix, "");
    this.distanceMatrixes = new List<DistanceMatrix>();
    this.distances = new List<double>();
    }
    
    private double[] GetColum(double[,] array, int columNumber)
{
    List<double> listElem = new List<double>();
    for (int i = 0; i < array.GetLength(0); i++)
    {
    listElem.Add(array[i, columNumber]);
    }
    return listElem.ToArray();
    }
    
    private double CalculateEuclideanMetric(double[] firstArray, double[] secondArray)
{
    double distance = 0;
    
    for (int i = 0; i < firstArray.Length; i++)
    {
    distance += Math.Pow(Math.Round(secondArray[i], 6) - Math.Round(firstArray[i], 6), 2);
    }
    distance = Math.Sqrt(distance);
    
    return distance;
    }
    
    private DistanceMatrix InitDistanceMatrix(FourerMatrix firstMatrix, FourerMatrix secondMatrix)
{
    double[,] distanceMatrix = new double[firstMatrix.array.GetLength(1), secondMatrix.array.GetLength(1)];
    for (int i = 0; i < firstMatrix.array.GetLength(1); i++)
    {
    for (int j = 0; j < secondMatrix.array.GetLength(1); j++)
    {
    distanceMatrix[i, j] = CalculateEuclideanMetric(GetColum(firstMatrix.array, i), GetColum(secondMatrix.array, j));
    }
    }
    return new DistanceMatrix(distanceMatrix);
    }
    
    public void CalculateAllMatrixDistance()
{
    for (int i = 0; i < fileMatrix.Count; i++)
    {
    distanceMatrixes.Add(InitDistanceMatrix(currentMatrix, fileMatrix[i]));
    }
    }
    
    private double CalculateMinDistance(DistanceMatrix matrix)
{
    double[,] d = new double[matrix.array.GetLength(0), matrix.array.GetLength(1)];
    double[,] count = new double[matrix.array.GetLength(0), matrix.array.GetLength(1)];
    
    for (int i = 0; i < matrix.array.GetLength(0); i++)
    {
    for (int j = 0; j < matrix.array.GetLength(1); j++)
    {
    List<double> list = new List<double>();
    List<double> listCount = new List<double>();
    if ((i == 0) && (j == 0))
    {
    list.Add(0);
    listCount.Add(0);
    }
    else if (i == 0)
    {
    list.Add(d[i, j - 1]);
    listCount.Add(count[i, j - 1]);
    }
    else if (j == 0)
    {
    list.Add(d[i - 1, j]);
    listCount.Add(count[i - 1, j]);
    }
    else {
    list.Add(d[i - 1, j]);
    list.Add(d[i - 1, j - 1]);
    list.Add(d[i, j - 1]);
    
    listCount.Add(count[i - 1, j]);
    listCount.Add(count[i - 1, j - 1]);
    listCount.Add(count[i, j - 1]);
    }
    d[i, j] = matrix.array[i, j] + list.Min();
    count[i, j] = 1 + listCount.Min();
    }
    }
    
    return d[matrix.array.GetLength(0) - 1, matrix.array.GetLength(1) - 1] / count[matrix.array.GetLength(0) - 1, matrix.array.GetLength(1) - 1];
    }
    
    public void InitDistances()
{
    for (int i = 0; i < distanceMatrixes.Count; i++)
    {
    distances.Add(CalculateMinDistance(distanceMatrixes[i]));
    }
    }
}
}

