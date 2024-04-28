using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShellTexturedGrass : MonoBehaviour
{
    [SerializeField] private Mesh mesh;
    [SerializeField] private Shader shader;
    [SerializeField, Min(2)] private int shellCount;
    [SerializeField] private float density;
    [SerializeField, Min(0)] private float height;
    [SerializeField, Min(0)] private float minHeight;
    [SerializeField] private Color color;

    private readonly int
        indexId = Shader.PropertyToID("_Index"),
        shellCountId = Shader.PropertyToID("_ShellCount"),
        densityId = Shader.PropertyToID("_Density"),
        heightId = Shader.PropertyToID("_Height"),
        minHeightId = Shader.PropertyToID("_MinHeight"),
        colorId = Shader.PropertyToID("_Color");


    private void Start()
    {

        for (int i = 0; i < shellCount; i++)
        {
            GameObject shell = new GameObject();
            shell.transform.SetParent(transform);
            shell.transform.SetLocalPositionAndRotation(Vector3.zero, Quaternion.Euler(0, 0, 0));
            shell.transform.localScale = Vector3.one;
            MeshFilter meshFilter = shell.AddComponent<MeshFilter>();
            MeshRenderer meshRenderer = shell.AddComponent<MeshRenderer>();
            Material material = new Material(shader);
            meshFilter.mesh = mesh;
            meshRenderer.material = material;
            material.SetInt(indexId, i);
            material.SetInt(shellCountId, shellCount);
            material.SetFloat(densityId, density);
            material.SetFloat(heightId, height);
            material.SetFloat(minHeightId, minHeight);
            material.SetVector(colorId, color);
        }
    }
}
