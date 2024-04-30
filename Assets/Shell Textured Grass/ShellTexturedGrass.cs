using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShellTexturedGrass : MonoBehaviour
{
    //[SerializeField] private Mesh mesh;
    [SerializeField] private Shader shader;
    [SerializeField, Min(2)] private int shellCount;
    [SerializeField, Min(1)] private float density;
    [SerializeField, Range(0, 1)] private float scarcity;
    [SerializeField, Min(0)] private float height;
    [SerializeField, Range(0, 1)] private float minHeight;
    [SerializeField, Min(0)] private float heightAttenuation;
    [SerializeField, Range(0, 1.42f)] private float baseWidth = 1;
    [SerializeField, Range(0, 1.42f)] private float tipWidth = 0.5f;
    [SerializeField] private Color baseColor;
    [SerializeField] private Color tipColor;

    RenderParams renderParams;

    private readonly int
        indexID = Shader.PropertyToID("_Index"),
        shellCountID = Shader.PropertyToID("_ShellCount"),
        densityID = Shader.PropertyToID("_Density"),
        scarcityID = Shader.PropertyToID("_Scarcity"),
        heightID = Shader.PropertyToID("_Height"),
        minHeightID = Shader.PropertyToID("_MinHeight"),
        heightAttenuationID = Shader.PropertyToID("_HeightAttenuation"),
        baseWidthID = Shader.PropertyToID("_BaseWidth"),
        tipWidthID = Shader.PropertyToID("_TipWidth"),
        baseColorID = Shader.PropertyToID("_BaseColor"),
        tipColorID = Shader.PropertyToID("_TipColor");

    private void OnEnable()
    {
        renderParams = new RenderParams();
        Material material = new Material(shader);
        renderParams.material = material;
        material.SetInt(shellCountID, shellCount);
        material.SetFloat(densityID, density);
        material.SetFloat(scarcityID, scarcity);
        material.SetFloat(heightID, height);
        material.SetFloat(minHeightID, minHeight);
        material.SetFloat(heightAttenuationID, heightAttenuation);
        material.SetFloat(baseWidthID, baseWidth);
        material.SetFloat(tipWidthID, tipWidth);
        material.SetVector(baseColorID, baseColor);
        material.SetVector(tipColorID, tipColor);
    }

    private void OnValidate()
    {
        if (renderParams.material != null)
        {
            renderParams.material.SetInt(shellCountID, shellCount);
            renderParams.material.SetFloat(densityID, density);
            renderParams.material.SetFloat(scarcityID, scarcity);
            renderParams.material.SetFloat(heightID, height);
            renderParams.material.SetFloat(minHeightID, minHeight);
            renderParams.material.SetFloat(heightAttenuationID, heightAttenuation);
            renderParams.material.SetFloat(baseWidthID, baseWidth);
            renderParams.material.SetFloat(tipWidthID, tipWidth);
            renderParams.material.SetVector(baseColorID, baseColor);
            renderParams.material.SetVector(tipColorID, tipColor);
        }
    }

    private void Update()
    {
        Mesh mesh = GetComponent<MeshFilter>().sharedMesh;

        //renderParams.material.SetMatrix("_Matrix", transform.localToWorldMatrix);
        Graphics.RenderMeshPrimitives(renderParams, mesh, 0, shellCount);
    }
}
